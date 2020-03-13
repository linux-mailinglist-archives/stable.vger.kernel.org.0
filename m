Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D61848D8
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 15:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgCMOJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 10:09:23 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39753 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgCMOJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 10:09:23 -0400
Received: by mail-ot1-f67.google.com with SMTP id a9so10201574otl.6
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 07:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=HkTg2l81dVARODKvDV4LiJ911oOSk/1lFbaHd5CQuJc=;
        b=TAhtBoeq38MDzm5VUQ+6MxK7C3uQ+8nZWcpmwkdjQ6upK1+9uHRuAMq0EE5KyVg9+x
         gXKAcV9XtPAB/bQGKNrmZiaN8NplTG0mWXUgJh+BH776HQkhpzHV7iNq44VfaRFW5Ici
         zPQTnfNjlkR2yGmuMSNx7uVWZC1KCgqquUkvVK3I2X+xdgWG8+b4CqWi+36IPHG1FHCR
         YdCwugjgZqSsSi4743zAWebAaI0jDymJaVAs1mW2NCXac57/ncQx1nk04ngEEhEOIQbJ
         m/FyaFWv1c0CKo12ROHo3SvQXXl483nujkqaLTQ7KgS3jeWqwIzUiSerBVj5NuKnBY9O
         rxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HkTg2l81dVARODKvDV4LiJ911oOSk/1lFbaHd5CQuJc=;
        b=e6PtL5RqeqXfrTzaMDlHsY7m6GiBxgbBbdHr63DkZeQ/wvPP0OyQWksLCe9xQP/3QB
         9ygKyPlkPx8zp2vLIXzPuUOk1IieXdze7CyUOqqp98X1BDC+HeYnVLFqqCHiDsIVByLT
         v6UxVUPari5DOY+pio1FXXIhf2f6BJ4MGszesXJ6U5yA4XXzLLV626Hb3WEIdwLmKrKq
         qJLebsfoR28BzfMWX/tp3qKu9Rgs8s9z4iRtRmcEV3DcfNvd2/VlHWrqfN/L1MA8wmDQ
         0a33QP0Gef/TMGmWGFPU9VPAq0pGqm8QRvkGv2tsRvpB98Nk+xk2ozAt5Ozsvv9YqPjo
         xQJA==
X-Gm-Message-State: ANhLgQ1v5PZg2FjceeI30mrnq8ZtZpOCRgyI5CEbNE1g/HlbPSbLmKGT
        sbH2NrRrGmPTuHJNNzr2YxTFbrc5O2xeEj76ub2hu2yq
X-Google-Smtp-Source: ADFU+vsoSU4RyEx2vgzrV6r0RJEMoKrKegUmCH7MvEuQ37SzHC9e0gg9pxqSgFWWEQUUAlTg5r+IMIS6SX0+Q/7XIh0=
X-Received: by 2002:a9d:895:: with SMTP id 21mr10794855otf.365.1584108562651;
 Fri, 13 Mar 2020 07:09:22 -0700 (PDT)
MIME-Version: 1.0
From:   Martin Galvan <omgalvan.86@gmail.com>
Date:   Fri, 13 Mar 2020 11:09:11 -0300
Message-ID: <CAN19L9Fi0h0wHOyY3zdAU4vX=J+T_3sVkL_wsq89W+RgF7gBxA@mail.gmail.com>
Subject: [PING] EFI/PTI fix not backported to 3.16.XX?
To:     pasha.tatashin@soleen.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I've been running some tests on Debian 8 (which uses a 3.16.XX
kernel), and saw that my system would occasionally reboot when
performing an EFI variables dump. I did some digging and saw that this
problem first appeared in 4.4.110 and was fixed by Pavel Tatashin in
commit 7ec5d87df34a. At the same time, 4.9.XX, 4.14.XX and mainline
have commit 67a9108ed431, which also solves the issue. However, the
3.16 stable line doesn't seem to have either fix, and therefore the
crash is still there.

I don't know whether any distros use 3.16 other than Debian, but it'd
still be good to have this fix backported as well.
