Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCFA1E4514
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgE0OC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730223AbgE0OC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 10:02:27 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A1C08C5C1;
        Wed, 27 May 2020 07:02:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l73so1131907pjb.1;
        Wed, 27 May 2020 07:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7uwEzD/HWCPds3dRM6BjnO0kf4LNMewfvGxCPu1qZms=;
        b=jQ7o/CVPWMv45D5ntz5OrfDwxQ4ADwJoiKFZ4pXty989UbswPKAS+EC6zYjk/oeY7O
         p0uKRTBJrGsusvVJG5JS/72k8iZOU7fsh4wrEssatYx7/drmJkOkBLfGgMEypqR5o0VU
         vGhsAurVvV7FJ2jracv5fsurwmMbwPp40mLPsb2CiRjez03b4V8LYJYCQuaps3bfpMCm
         nLbIA4QwUUpXL8ED9IRsJQ/GdDQ3n6NjN3UJRt63JTbWvQlxqYuiUaoNnTqqYIFvgc7M
         wzgrPXx7TAaAwv607yAMO8WpzhR/GIURKyFfCdFq8mOarGZYmE0wJNjXlp0nqfN9fBkz
         gwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7uwEzD/HWCPds3dRM6BjnO0kf4LNMewfvGxCPu1qZms=;
        b=HStfp2T3zSP0CCcIjhLDbgk45I7Otbbcetezwv/julusW3JW5HoFLnkwE+OMe/QTuL
         qp6wJyD0VT6vFVVlpQdfLnMvgP7ixwo5P03zfbUveUQTGjOtLVqVuHPswCvt5fg6Zlvc
         BbphI/uIV1ckS85cUFEdH4apaCnPf3aVZYyI1R8wYq5hL5zFSx45jky3jRAsDj+/4A+z
         ExGa56IPNiz2iKZNvr1B1MN8wu1HuACy8SQYAh5188UtRnDPthRRFAB03YJ7Gxi0OdVR
         F3BNpE8269J1/1gMG4RAl3/eWTOv1kGMXi0g9C4qnKmFLvfzOrmNL1ZiUDecJY0UCYW7
         cRMQ==
X-Gm-Message-State: AOAM5305Akdt62PBd1SdFKf0VnNvM4/qRTonyXo3kpslMaQlsWR9EhOo
        hzu6CJPwxvDeBYubJimOV8k=
X-Google-Smtp-Source: ABdhPJwrpunqhiqIubL3gDTU9v4epZDlGYzSMJFRk0p6+g/cb0ckrIZAayc1xxklodbCuIJLAMRdNg==
X-Received: by 2002:a17:90a:6b08:: with SMTP id v8mr4969897pjj.151.1590588147261;
        Wed, 27 May 2020 07:02:27 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gz19sm2488833pjb.33.2020.05.27.07.02.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 May 2020 07:02:26 -0700 (PDT)
Date:   Wed, 27 May 2020 07:02:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/81] 4.19.125-rc1 review
Message-ID: <20200527140225.GA214763@roeck-us.net>
References: <20200526183923.108515292@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:52:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.125 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 390 fail: 31
Failed tests:
	<all alpha>
	<all sh>
	<all sheb>

Bisect log (for alpha) below. Reverting the offending patch fixes the
problem. Note that the problematic patch is associated with several
other patches in the upstream kernel. Not all of them have a Fixes: tag,
and I am not sure if all of them reference the problematic patch.

Guenter

---
# bad: [59438eb2aa125985caa11179358001f38df0bc7e] Linux 4.19.125-rc1
# good: [1bab61d3e8cd96f2badf515dcb06e4e1029bc017] Linux 4.19.124
git bisect start 'HEAD' 'v4.19.124'
# good: [cf97abff88a2d1b1f6ce1cbde6e17133812b40ea] ALSA: hda/realtek - Add more fixup entries for Clevo machines
git bisect good cf97abff88a2d1b1f6ce1cbde6e17133812b40ea
# good: [14179ae15e2fd47223a6c05d4580def2c60869ab] cxgb4/cxgb4vf: Fix mac_hlist initialization and free
git bisect good 14179ae15e2fd47223a6c05d4580def2c60869ab
# good: [d314b90fcd2704c1c9babb4c35c0dc835c711e2f] ipack: tpci200: fix error return code in tpci200_register()
git bisect good d314b90fcd2704c1c9babb4c35c0dc835c711e2f
# good: [76955a85caf40f3edf72a5f346083c14ae3bf843] iio: adc: stm32-adc: fix device used to request dma
git bisect good 76955a85caf40f3edf72a5f346083c14ae3bf843
# good: [ff4ab7bb44c4b4007898be3d3a8e1ad51b1981eb] rxrpc: Trace discarded ACKs
git bisect good ff4ab7bb44c4b4007898be3d3a8e1ad51b1981eb
# bad: [dd2e65505bbed0631d642b0f2539ee7894494a9b] make 'user_access_begin()' do 'access_ok()'
git bisect bad dd2e65505bbed0631d642b0f2539ee7894494a9b
# good: [d25981b4d48f68871daf41bc0ca7f89c160a4b7c] rxrpc: Fix ack discard
git bisect good d25981b4d48f68871daf41bc0ca7f89c160a4b7c
# first bad commit: [dd2e65505bbed0631d642b0f2539ee7894494a9b] make 'user_access_begin()' do 'access_ok()'
