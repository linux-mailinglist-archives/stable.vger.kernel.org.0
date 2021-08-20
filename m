Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59DF3F2B44
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 13:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhHTLcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbhHTLcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 07:32:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D31C061575
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 04:32:06 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i9so19900167lfg.10
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 04:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=EVr+GNugLlc0xK2l3OQNOEkKJ5gDmo5J6cp/NzY4KIo=;
        b=g/3GoAXQr+Zsw0lPoKFQZYQh188zcYIgkRHgolRW4BAYH5vDkDa3t30oI3maG67g+9
         qimz4WKmeJojSDgZLB//aoTg9r3om/iNXuycfdDIf6J1BcNqxbf606hMhPnpgvGeDDe6
         ssaoidENTRZfHWdZjj+seAo83GcDfPc3im52/yy/hSnScMtQJl7hsKy5MlLY6EdWbyn8
         MdlXPz/k5loeuCpGynJHi57Jfno5HvYndjUD7sJSWBUPUcsvejSfs9bD+hZXHOo08Bbt
         Anrd39TVse5YwDotsyU4W4wUWxC98Xb84HT3Eklq6GurqBO8EKEHqjb6lXEDAZUplxTb
         9NeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=EVr+GNugLlc0xK2l3OQNOEkKJ5gDmo5J6cp/NzY4KIo=;
        b=uJxhzElFQPghYLvAHLUMRf9e8Lg82gdoyd8w27AufADt+CcqoC9JnmLbabaurewr/5
         67sx343wJoid1waEomK642SSGFlp3v2rPuyEf0A1IzdJ79UkTCQTUrUgORduI3mCkDgu
         jj5ZciqClJl/PBuBl4aUUk+GYMkIY3M6PCjhwBffUspRwdoacYwIiluFdmjk9BiD26BM
         w+3z1y9/LVJOX+RNf22RMxhT0gEA1FFlgzvTngISkdXTSLv0FPMDHDq2UENVg1psKJAg
         YG2GJ3/g6zR0sJSmaNIinlPzMp7TixDpG15fq1z5sWaqreg6kC36W6KEMeYIWbwEtXed
         LX2g==
X-Gm-Message-State: AOAM531pOFoOddEiXvcVBwR/ylrI+Euh64BVrmk24Ftm0FD/btK9h+Wq
        LMNJ2PUtlfo7InNFdhxRY1Cq/nZ/0LeQ/6Vn9lM=
X-Google-Smtp-Source: ABdhPJwUpazCi6+rLA7TqFQIwbQLQrmi3YZKldb5iTSemSdHVLrEbMhZQytUo9Ll6yJTj+k7pwAtaDMLkZc+spB1c2s=
X-Received: by 2002:a05:6512:ac4:: with SMTP id n4mr14261344lfu.475.1629459124770;
 Fri, 20 Aug 2021 04:32:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac2:443b:0:0:0:0:0 with HTTP; Fri, 20 Aug 2021 04:32:04
 -0700 (PDT)
Reply-To: frankedwardjnr100@gmail.com
From:   Frank Edwardjnr <dcurtis2030@gmail.com>
Date:   Fri, 20 Aug 2021 12:32:04 +0100
Message-ID: <CAPdAYp7foS=x1uJQQ1o67LTiX2qZV3qMfyRo6DgD-9ZqNNBPig@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQpJIGNhbGxlZCB0byBrbm93IGlmIHlvdSByZWNlaXZlZCBteSBwcmV2aW91cyBlbWFp
bCwgcmVwbHkgdG8gbWUNCmFzYXAuDQpGcmFuaw0KDQrslYjrhZXtlZjshLjsmpQNCuuCnCDri7ns
i6DsnbQg64K0IOydtOyghCDsnbTrqZTsnbzsnYTrsJvsnYAg6rK97JqwIOyVjOqzoCDsoITtmZQs
IOuCmOyXkOqyjCDtmozsi6ANCuu5qOumrC4NCuyGlOynge2VmOuLpA0K
