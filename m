Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE252AA8F5
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 04:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKHDFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 22:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgKHDFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 22:05:14 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F60AC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 19:05:14 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id t16so6143381oie.11
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 19:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=uSpml2OGVg3iy2vrZSB/d1Fesvl1Axxjk/8IBs3A2BE=;
        b=kDI6WCiDQXyYxta73vrkfXI5zIY89Z0GW1u2ykPPPupDDenG1L4Zz1PrvZzzBJZrAD
         9M+Zx6MHYtwrrVyDNoQpA87jURsB3R+EGDLskAFJ8mOm3o5ZUmj8IFYzOsBf1STIN7Gf
         Y0BjTn9/wabhk0smTxaUTLAMRFHDuWQO3wJEpDyAg91KA5dZWFvrhva9wGUPgnuWFkQj
         1zedB+vO8/SutMDVOQ8gLMuyo+qD5P5LToEkVKagPt69WziqwLVBjIDpf4uL/TXF3vAv
         G0iKaGeZqc367pE7wm0DNNU88plrpd/BdR+qy2LROY2WMSBx7GmeaJbBoPAE32i+U+gs
         2D4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=uSpml2OGVg3iy2vrZSB/d1Fesvl1Axxjk/8IBs3A2BE=;
        b=Cemu5R/I4LfDvzELtBU7rMmXEbCXA3feNYBUWuK8Qxk79SfgiyFDw9HMQDWbsTJMoS
         VCQmzoab9bhV/THdIUFsVSOJxarGAOOWIVucau9DwhWkP9a6T2ikkwz9IbhtbZihnptg
         5Is8gPE5MCQT1CtOJOBChHOGv2dsxjgJvxxZjk0gDi6EG/FEVp3rfrpnqJlAAEmXxzKN
         fRrMIVuNR/BMfeu1dbH5PsGwWLROVcHr4+3goMCr208YkY//IjDSNHBiUP7k3Qyn2+S5
         7SoAeBLkYIv1Ux5PnEzjXoyIRuM/6TMoj62i8z9SZGqIHFD/tMpa1HNiCOxaKan8Yjvj
         bhcw==
X-Gm-Message-State: AOAM533tz16mduDV1wu+80hs0DfuyoqG1Yr6D67SVKsIAF4UGA08cyM/
        rwY+wAzLakSg6kaR9XhPwJ0=
X-Google-Smtp-Source: ABdhPJwai+VJEGmcaFzNRY0bdqh712AwXyvooc+ehyI0P2YmncGO0iqjkbjEo3/EGxFEXP3feWz7QA==
X-Received: by 2002:aca:ed86:: with SMTP id l128mr5218984oih.0.1604804713834;
        Sat, 07 Nov 2020 19:05:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h136sm1487347oib.19.2020.11.07.19.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 19:05:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Linu Cherian <lcherian@marvell.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please consider reverting commit bb1860efc817 ("coresight: Make sysfs
 functional...") from v5.4.y
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <5500643d-5813-d731-0181-bc57e6d33e5a@roeck-us.net>
Date:   Sat, 7 Nov 2020 19:05:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I get the following build warning in v5.4.75.

drivers/hwtracing/coresight/coresight-etm-perf.c: In function 'etm_setup_aux':
drivers/hwtracing/coresight/coresight-etm-perf.c:226:37: warning:
			passing argument 1 of 'coresight_get_enabled_sink' makes pointer from integer without a cast

Actually, the warning is fatal, since the call is
	sink = coresight_get_enabled_sink(true);
However, the argument to coresight_get_enabled_sink() is now a pointer.
The parameter change was introduced with commit 8fd52a21ab57
("coresight: Make sysfs functional on topologies with per core sink").

In the upstream kernel, the call is removed with commit bb1860efc817
("coresight: etm: perf: Sink selection using sysfs is deprecated").
That commit alone would, however, likely not solve the problem.
It looks like at least two more commits would be needed.

716f5652a131 coresight: etm: perf: Fix warning caused by etm_setup_aux failure
8e264c52e1da coresight: core: Allow the coresight core driver to be built as a module
39a7661dcf65 coresight: Fix uninitialised pointer bug in etm_setup_aux()

Looking into the coresight code, I see several additional commits affecting
the sysfs interface since v5.4. I have no idea what would actually be needed
for stable code in v5.4.y, short of applying them all.

With all this in mind, I would suggest to revert commit 8fd52a21ab57
("coresight: Make sysfs functional on topologies with per core sink")
from v5.4.y, especially since it is not marked as bug fix or for stable.

Thanks,
Guenter
