Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B9A1B4E9F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgDVUyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVUyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:54:04 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF6BC03C1A9;
        Wed, 22 Apr 2020 13:54:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t4so1406961plq.12;
        Wed, 22 Apr 2020 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WQ+ndOi2lW2mwlZWhjuTlZcQI7e3ptOBgifi4nt/2MA=;
        b=VzK6+hoYJVycmDoegv2Ow3hGeU30Lrw+VbkwntGanDZf5gRKTr8U2+S2DWDJP86AiE
         UnnV4fdzOuGc3o0WhqCxlnmP0nw595xOTrS1vtMsG2OwgYryaJRNXsZ8rUilWk/WHJhG
         Rv8dEZBrlGSFJdf/8+/OAUxSMKnLUq9DuXU3A5putQr0MrIKsc00z5k/Cq794TwwxAA3
         qtmQRddYRYlbDujLmD2TnblJGZ8FC8X0Tx4QgUlTLTmtmUJr5E8hJsxnqrFn86W+EVV3
         VaTKTUY9uUZhz89xUvGSUUvAfIzNGdmiPBkVpONr7iaBFwpI7Qk5DtmIVzVPXXpDuG1N
         zxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WQ+ndOi2lW2mwlZWhjuTlZcQI7e3ptOBgifi4nt/2MA=;
        b=G2ulgatZLY1341YNrQuWsKU2xjyNjIQ75nTiAfP41/601jef3MV1PG0B1J3R35VO+6
         aukibP+0sYtuXXzO4/7SsYkkEGPpyMkavX/fRpWKM5aw3IWjF79LtHQf/G58nvyrOUNm
         G2LykPaaF/W7XLP9HkU2X3VKuuCCTsI+1l4eT/tvP+kBfcjnC2MMeV2iH3cgSeihWmeN
         BRLMLC6is/Svfp94Y+I5hIFzM7RIavQSF65C5vOImkKYpNe7aO3lc1RngXiA3nFVEfWc
         kGDNITsNknjgZDSGINN45aS0SHw07fLbVcSpxhEQPzgBxVVmy+VdCxJ8G2x3t372ymdd
         Hm3g==
X-Gm-Message-State: AGi0Pub2GX4laAIbR28cAAdH84zNqKioZDDr5vc4QHU4vuzynZ32U+zU
        9ELq8DvJdkQJydfpSiKAj728NtFo
X-Google-Smtp-Source: APiQypIFSd2L8af/WjiAiaaJmn2gqUxq+plgOgdy8HxzcNiL02Zt38yxlL5J0/io7yq9UHV4iT74pg==
X-Received: by 2002:a17:902:b108:: with SMTP id q8mr583645plr.214.1587588843625;
        Wed, 22 Apr 2020 13:54:03 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w16sm100299pgf.94.2020.04.22.13.54.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 13:54:03 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:54:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/125] 4.9.220-rc1 review
Message-ID: <20200422205402.GA135017@roeck-us.net>
References: <20200422095032.909124119@linuxfoundation.org>
 <20200422203430.GA52250@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422203430.GA52250@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 01:34:30PM -0700, Guenter Roeck wrote:
> On Wed, Apr 22, 2020 at 11:55:17AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.220 release.
> > There are 125 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I see a number of unit test crashes in ppc images. Looks like UAF.
> This affects 4.4.y, 4.9.y, and 4.14.y. I'll bisect.
> 

Bisect log attached. I suspect the real culprit is commit a4f91f0de905
("of: unittest: clean up changeset test"), or at least it changes the
code enough for the offending patch not to work in v4.14.y and older.
Either case, reverting upstream commit b3fb36ed694b ("of: unittest:
kmemleak on changeset destroy") fixes the problem and thus needs to
be dropped from v4.4.y, v4.9.y, and v4.14.y.

Guenter

---
# bad: [f6cef26090da1763de1a7fc87205c8442d57bc80] Linux 4.9.220-rc1
# good: [5188957a315f664d46ff58fedecbc0f7503f1b22] Linux 4.9.219
git bisect start 'HEAD' 'v4.9.219'
# good: [0a499a93529e488ccccf83493c48e82b0bdea615] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry
git bisect good 0a499a93529e488ccccf83493c48e82b0bdea615
# bad: [f0b256f314141838039a084b81750d7a9dbc1e16] scsi: ufs: make sure all interrupts are processed
git bisect bad f0b256f314141838039a084b81750d7a9dbc1e16
# good: [9eb52f304182868156a97244618a09898d2dc37b] mac80211_hwsim: Use kstrndup() in place of kasprintf()
git bisect good 9eb52f304182868156a97244618a09898d2dc37b
# good: [cddafffc473da45d9eb419000ab9409824ef8f20] scsi: sg: add sg_remove_request in sg_common_write
git bisect good cddafffc473da45d9eb419000ab9409824ef8f20
# bad: [19976f5df09c19ce1bb0563055586998dda609dd] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
git bisect bad 19976f5df09c19ce1bb0563055586998dda609dd
# bad: [9dbcfb15960da712fc134b5d4a133386721497c5] of: unittest: kmemleak on changeset destroy
git bisect bad 9dbcfb15960da712fc134b5d4a133386721497c5
# good: [52b90d68b8c200b86e66434e0bc86e87510863f3] ALSA: hda: Don't release card at firmware loading error
git bisect good 52b90d68b8c200b86e66434e0bc86e87510863f3
# first bad commit: [9dbcfb15960da712fc134b5d4a133386721497c5] of: unittest: kmemleak on changeset destroy
