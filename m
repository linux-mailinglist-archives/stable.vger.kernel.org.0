Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C227C39A09B
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 14:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhFCMNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 08:13:40 -0400
Received: from mail-qv1-f44.google.com ([209.85.219.44]:44876 "EHLO
        mail-qv1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFCMNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 08:13:39 -0400
Received: by mail-qv1-f44.google.com with SMTP id a7so3016905qvf.11
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 05:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9HfoGm81jYfhBHcG/hnRagxu7vyw/xrxt44Gts7PTDU=;
        b=DmRxdkNJSU1ERJ8Of4hn/BxqNBjyszg3wW6gt9efnhwnNBVRp9LGNyTYcAS3cFzcG2
         zzZXiulbTabIJKlT6yQQsl9y58f1k3ks427/Oq6rCPWhwPPTesW9x9bHpUTsgtnzK2Im
         bpqAAHPcDVkTetJsIvuuWRK/TmxgVqGZi3SQpBTc1U4QRE+4/coNLFEeuEjCFkk0qpuu
         KavlPG/SP5ed1PL8HNmO3T0cknAEi0wu8A82Z/5UAtchEI2AJOChCHjnXT0gWyZKr8Sx
         hZiba9UJTjSkOrDODCs3J2XO33cyC6faXFnsPn+CuCb/rtqaI6e79F7fOG7Q6zJFb7W2
         kRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=9HfoGm81jYfhBHcG/hnRagxu7vyw/xrxt44Gts7PTDU=;
        b=M4w/nEuKnMkybZS5dlOa6gNzQqglYfsxF8rB4/PZ8jvQrlNP3MNaKY/sFPlwAUULX4
         R45YZA0yRp8Pk25fu1/msdV7Gito9Ull1PAinnzFNIJzatpkUAlRgth+rJnEOaWyq+ey
         W6yLsK0XWaH5l2v1qHfS5hzOKE1tNpaxfpwvUtDUmRLRoxTNz3HHl1ZY3DMFDm4z8tg8
         y0PWT3pwVAYLkHniQAng9B5/pYreB7slApVFvfV6J8EQawFikDOFUJ7WB28F0wTX0jv2
         tgNyBMY5KJpR9RJt4b+ho6MGNSdrzTd/8ki0mQEauKMTSoFf0HK3yZ8elFN3FZsmwueH
         xHmw==
X-Gm-Message-State: AOAM531IoWWzrTQ1J3lMRgiaBfdSlY8f/f3fkXWBblXX3oAfa6IqHP6/
        xdDAi9J1cbf3K2ZdBC3ZZSg/4f/sRvI=
X-Google-Smtp-Source: ABdhPJz2WsMPHiuCcaFc+pia/qsJD/MGklI6rbBKaNJw5DHursrJgptvLxytIs9viBWZGWyDw361yg==
X-Received: by 2002:ad4:4b71:: with SMTP id m17mr30735633qvx.45.1622722242522;
        Thu, 03 Jun 2021 05:10:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 97sm1594915qte.20.2021.06.03.05.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 05:10:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 3 Jun 2021 05:10:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Please apply commit ff40e0d41af ("ALSA: usb: update old-style...")
 to v4.19.y, v5.4.y
Message-ID: <20210603121039.GA3017129@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please apply commit ff40e0d41af1 ("ALSA: usb: update old-style static const
declaration") to v4.19.y and to v5.4.y. It fixes commit a01df925d1bb ("ALSA:
usb-audio: More constifications") which was applied to v5.6 and backported
to v5.4.y and to v4.19.y.

Thanks,
Guenter
