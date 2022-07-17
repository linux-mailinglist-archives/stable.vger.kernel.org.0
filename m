Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01F05773F4
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 06:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGQEGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 00:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiGQEGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 00:06:22 -0400
Received: from sonic315-8.consmr.mail.gq1.yahoo.com (sonic315-8.consmr.mail.gq1.yahoo.com [98.137.65.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE151EC58
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 21:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1658030780; bh=cFQdqAlSWQ4CBg5sHoVyAua4lSY5DokrLNSjD/d1ri4=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=jlq14HhZZg105Ye1jFmKak3k9TWx6zGR/HCyAi8rDZpN78Y2mq5IxgDNeMZVZr/mjmQKjxIU4wVI7kHRonFTtCsa34JhoRl+QWl9XgG6SGKnSeavMRGUYvyCS9kh8jZNyLLGkoJzyGb2FWywrbXNtBmDiI1KC32j5iEnfsvK9WpgMws4bav7jmB1nL5iuw59pZeSH/GDa6x+g/xtgLr34m5dhTebcnKDDu56H5hf/tuxYE7f+UM8m+a9jv7uiPl+Z4alZjeFu4W0M+xm/2MU5VUZrsikuJKwIIdGrB8EeDDFoIYtIUU469chlwg1pquOmgzbzgL/Y8YGDtf4Np2sjA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658030780; bh=iqlz8AX8cYnQt049OzKCHJ20MTwlqIp5A81Hb3meSLv=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=txQuTHr8TkO44ag8sFyCZovVaIm3cTq7sp1ozY3hZJhGEPayLXVGNB43AYtk6ZDjz2lxQbYzHGwGrfD8+SjUVxpEb3ilYjqjUVco5HKOL6NVAoR44L/zmGVPYTAqV65WyySECJlucQo2J0QphTVRAT4ixGnC3Xnsm5LrwHf4j7cAaCiCNh69/8unfBqAdO9rkj7irJTwk/dIXwEct1QoP3xGb7m9vk2wQNfJyEX3CieyqKimHpce+RKEChdCn4DYNr+W4R6kAM3t3OTDPLf/Wa6U2fLEGtG/R4HvRuc9P/gSpGkgL0MJZuSzneeWKALjAbjpGDQteC33Z2uLa/6MTg==
X-YMail-OSG: i677T34VM1nRFvOlQ3CCChOdXznGaiPU.aGmFRK_C5Z0TVS00794IZFEwFz_kyn
 9Nc6NrfdrpuOvsnHiTaj0xHKidH3hubleVWZ5XrrRgMcloj3XI3QONjdrJsS9BAH.PhwsnlcDM7r
 oX9TnVbiSP9H53xdguWFFAASAzYTrcyppaGUTWbe9yQJYv1SKQ9sUCb8IlqG3Xvb0T1YffT8MGOX
 YaFlpxqWkUAbBAHilV9sXSfwN2oALmHXvdwpGulX5.N7VyxJNZuryKayCL0m6vbm72ID7vOUbzCr
 YbqboJ6.1bfeshChIFsH41YH1fSx5xAGcROZjhMvGfmajrToL4w40OoMegiUNL_FPBZrOeze419M
 WhvwxdLmG1QK.5yHopdGWX7B0YdpgEkPS9Fbc0B.qgOqR.f4VUwmXe5CSvVeWZdTx1.C55fLWWRS
 5X5.R7W.FNqAgAql5e7saQxs8bEEKbifrPm1vunCxjA_FMunrqqQIKNtk3sTnxQ8ZEuZb2Z4wozF
 SVKmt2B2.sSKMmPCL7qXpDW7.KZWAhL4bps1YCENARRU61_qAXcNYFmikoCS0ICkDMEveSi4lTS5
 5CE2LqN0el6eue1c4PwXxUevtF38NFbBhHCUZFpXe0fM8TECcYoRddz8DP6KGHCgEO_HBLslJctn
 E0xqfygKY7FpAkkkVRmt2UozB55x_F_sLFxNK8W1qPTYZGF5ydzozQA5lxnfdVDyAeYjl4S2hOQh
 Ak6UrhLbYQB_6XV.pSXPQDcjFHBJqkPT1GMidS0ACDu70drY_sYfrS5mT8RaMxY98WVqux7WAKXf
 1sD59mhWSHXOOX7jTGqmWYsDtPuaCu1RldLFyoIofwFB3_VYJJvXhXeEqiuupAWptn7ugbd1QTNw
 SzclM2wbfLOTqkjgvGc3ndx1BQbzlZNZbmMQLhJQUwi1hwqB_KS7XU9xqhUB2ch4YMpulSsup2Iw
 cxfHmZzQOkgOzLyt7wSZyLvL2aObHZ_uIheeT22LZkUtz2Um8ggvtjMY7tD7aS3S6nr45_aeLlI1
 R4e3WWFIGPFx3.B2ps5fVDO.oz8c_YA3dxcoPaodI4F0DyEQ3ARoW8M5FSv0_YsKnwryVMnS3Y0Q
 _NfuBIA2rO1s4gJQ_hlEiStezgo5Ce.PwkPsbkidKcmwCul.LNsnz1gkrlzSzegmKbwi1k0N2fCw
 x0HQ72QgngGu5u3jF_yhdlqDiBs_SB_ICafXzCea6ai8LQT_VUAqvi2ynWvR66yOHEyb7Q5AT_ti
 lPAoC.TD6Oaj9oT1kaGtk2PWfllLm0cp759hUmvX0Rj7YrpajkkMnYKyOFV0ZyiJ89jFFCsE7Tn9
 wPzqS.9A_4eM_wqPUvQOFGs8QJeEyKYd2MTxrGLb..8o5AQU19lvRrZx.YQv1H4tr1DiGHO84LtD
 bGaLHQCuqdfqh.kdri1IB7YcuPoD_vMz8O_exeyf3pqG9iISuvflxA.KM0X0bdZIcb2Ur12nLVov
 avgfc.RWbTNRAjGGQ21cKhbPDUv_3HpMHnHmbV_mIw08k2.pJHpRYJ57IsuiLhqwowLLSW3LnfQw
 lv5vMGJPtSCaK64q2UGhEGH34DUEfpQEH_WptKgJZM5G0PSQqz80FWTyW5fUpYc03U7czk9xBd8e
 umCsMznxG4L1dyPf7neH1twIhhCeMvKswhyeIEKOSHG0R_hwo0mfNLPJU11lw96NjRaFuCxrI.4S
 WOnDzoTA2jHUZ2HC6dKrSOKW2qNH0QS6XYNrkCAldD0EG6JF2u.ON9imN7WD_H9CbbgUyWKoivpu
 Als7OCsSAHQe_plMn0T.cOmrPDkQBFl.GWjLR7bTnFOVyNfzHweeellsvyOYqnbivFCdR_ZuBz5x
 r2VjjG9z0aKHSiJagHCbixvCyB_nVY4UK7_bcXEqHkq3oVefKZOvEPgqgrpT0djYJnLmdYevGxrZ
 fBXgS_zjvO9wddpe7JQx3Fzf5H9iugb8_uhllHbocmx4wZRHYh.JpTRIl_gPGZeZlJM3w4yrdNEH
 LhjB27QhfECh1grgbAhreJKhl81b4XeHLZXbp322Y6YInoBTnLQu0wHNEL0hzmZj6B19M9ExTfFd
 EGdLjVAkUzlKmUqPWCkcg2GWH3ZZ7YxyWDJx6tFXaK0HQ0w4QOCaQVw2wIXdTzCMVKkL9cATc2Ok
 U_YZSTW7N73UeJlrKZTUbT20qh6J94YR961j9l6hzoYvDuyyO2llJOX32qR4gSQwNMVEcdZQ2w9d
 6oJ9KzDZw_yU-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Sun, 17 Jul 2022 04:06:20 +0000
Received: by hermes--production-ne1-7864dcfd54-jmsp4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 76f19ee75a50bf95f5392cd0b76efdaa;
          Sun, 17 Jul 2022 04:06:19 +0000 (UTC)
Message-ID: <3be26f87-78d4-c2fb-0e27-db0196f9d62f@netscape.net>
Date:   Sun, 17 Jul 2022 00:06:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/3] x86: make pat and mtrr independent from each other
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "# 5 . 17" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20220715142549.25223-1-jgross@suse.com>
 <7bf307c7-0b05-781b-a2a3-19b47589eb8a@netscape.net>
 <YtKkECIpM5q+TCT9@zn.tnic>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <YtKkECIpM5q+TCT9@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/2022 7:42 AM, Borislav Petkov wrote:
> On Sat, Jul 16, 2022 at 07:32:46AM -0400, Chuck Zmudzinski wrote:
> > Can you confirm that with this patch series you are trying
> > to fix that regression?
>
> Yes, this patchset is aimed to fix the whole situation but please don't
> do anything yet - I need to find time and look at the whole approach
> before you can test it. Just be patient and we'll ping you when the time
> comes.
>
> Thx.
>

I will wait until I get the ping before trying it.

Thanks,

Chuck
