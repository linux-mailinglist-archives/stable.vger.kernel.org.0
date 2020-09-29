Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9CE27D9CB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 23:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgI2VM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 17:12:59 -0400
Received: from sonic315-21.consmr.mail.ne1.yahoo.com ([66.163.190.147]:42613
        "EHLO sonic315-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgI2VM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 17:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601413978; bh=ShrdGJTCUVMCJqYIFt8iS0epc16DuED8/NfeEkfRx3o=; h=Date:From:Reply-To:Subject:References:From:Subject; b=cusJNUFnZQ5mvSQEkLP2eiWgdkg/kFQLSiVHx4g3jnslCdIO2KUoxFSu7nbxtSf6Piy2b/UnAuOZdbhThHNrPsmfrSLB+0T0h0UqsOZa9N+lfp8gCMxp92HEY96YQxoLqLH/0fXim0D4wE9B3arzsB47jrf6RJOYeLNFI38t0P3YbjQGBKGtUXYa+4soA3SsP97K9V5OLX783IKKGVwp4vsw1c/Kl+AAOteOmY0kcDqfYfhYQEcEs+qkDpkdDcAg0xdSlZug2RpmFgTBIst5NW9Km5ZBne7+4Csk/VmpsuBO60ECO7yIvf+VWSkXZ54Aha3SOhGw1jLvkKcI6wCVMg==
X-YMail-OSG: ytKzfikVM1kvcpQep5OP6lMsuz7ZQqbuAKmfyZqSR6riUvmJ212JdCzpmrNbRea
 e9zjF5keGLOlo843Cr6m3ZVfZcVEhpxxqstQKoDhax23a42BWkUWJBZdQ0Zt1BT7b6JsuKdKiM.H
 7TdNq1KQBleyQKsTQbtuyYcO2S7mGBSymmiC6UgwG9_PVL75qQv3M79nbCu1fnPVcjcKMHLetfQ7
 I1eZf_aT.GiYCepenjoKZNA_lETeBJC8P4nCqhjHZT4_feLLB8Q86vgnRs3S4C4DoksKp2Lpz50v
 8mrMUu9CRWrUbxNXzIiTZIB3tnT3RQKrzipnP46X4lHASwffb3fakCdZDFLy589iyTMfi9PdcQsX
 R2tFuXRh9bGWFywESVXB1Ed62oPbSkBXYD6IRqlXiyWD2.yROXbgAoxyAaVb.LVFVpL4jCsDph65
 5G3jNO8ZGfYm4PnyCscnxdC1U3yx37ekcUI6S._yRgNycT5vj9_vgh3f_ncDarCEKjbGOqjfUKtZ
 IGrXpLKwGeYxlhgGmwsCMv.I2uzYe.zsO.VsGBCMgivczVLjOwAzJGoqMh0_9J4c9QjSYEXgxcbD
 yNZ2e4vKGlwW9NsIR10nxHVTQ9cSErH8ArxpzK5v4KyBw05oOyScvOAPjsa2fVvtT1xPSsoqTtSM
 qFVdPwcfVrlJlrLTxhm._o7ykRGxrHQJl8ttURK4UgbSDpLW2Ql5DefvU8Zg26aFoO9R2WGbq7MA
 Sbxi6sbyNo8nAHf8dsGY5AK9eVwJmR4sY58PcbuamTLK31q.vHVFrFp05LAppg3VWUK3DsNVDonX
 YqnRR9s.Dpsc.wFXp8Q4.sQxYGkhPFD66kjMfP.g69XnzKtBuzUkA8ByGqnr8jT7uuUx5h.2DwGX
 niDINndJ3__XCTTJPV1PGkU_AP5AbYomn6AKEpbFZL80gibwI3RbEzfEudj6vUgAJ.ajYph4W5X9
 uNYMZ30vc915OV7h2DdJtdLo4uySZdkUujnD4OVuNOY8a85ZBs_5DWQ1QxZ7vvBKXnF3kbnDwGDs
 SIFoN116q.OLc4CO5Mt5UlKYTCVg.ZDMy0wV_aNWsZ5iQNWbte549cuQUx6dMxOahTBJ2jlaLsZp
 85XM6mrTvF5UZ5biKQP3p58l0mOSbxB2h7dRRrpj8xOYF3BVsCDaXdHAFMuVTVOdVdM9CelU9zAe
 aHmbF2SK8VrWxi7iov0tHAxw1r.fDdDsaJlhTYd8DoSYIS4AvcTvSntuuxZhdIPj_96IG2DPkddv
 y_1UnJ5LpsiyBHtR3B9V_3qNor9f44vmbKck1YGu8Omj7u_.ivLnU1UQ5hPwjkRZd7Uol0QLX6nO
 Zmddt6LYqyq9esed6YqBAW_qnrDLN0iPOX0S64RYdYKMliIsgVkA6ZwA9nJVWAa5r.cTyzaZhtNj
 d66xO6BwVkQRE6gBIik8gMSwHca7PlFwdx20PxnGBjuz4Xq5nBUMN
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Tue, 29 Sep 2020 21:12:58 +0000
Date:   Tue, 29 Sep 2020 21:12:52 +0000 (UTC)
From:   Ali Shareef Al-Emadi <alishareefalemadi465@gmail.com>
Reply-To: alishareefalemadi465@gmail.com
Message-ID: <999753858.58951.1601413972992@mail.yahoo.com>
Subject: Dear Mr./Mrs.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <999753858.58951.1601413972992.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings.

I am Mr. H.E. Ali Shareef Al-Emadi, Finance and Account, Qatar Petroleum. I have $30m for Investment. Contact me if you are interested; I have all it will take to move the fund to any of your account designate as a Contract Fund to avoid every query by the authority in your Country.

I sent this message from my private Email; I will give you more details through my official
Email upon the receipt of your response to prove myself and office to
you.

Email Address: alishareefalemadi465@gmail.com

Regards.

Mr. H.E. Ali Shareef Al-Emadi,
Minister Of Finance.
Qatar Petroleum
