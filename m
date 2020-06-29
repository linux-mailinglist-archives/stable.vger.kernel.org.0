Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951BF20CB34
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 02:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgF2AdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 20:33:23 -0400
Received: from sonic312-25.consmr.mail.gq1.yahoo.com ([98.137.69.206]:43110
        "EHLO sonic312-25.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgF2AdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 20:33:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1593390802; bh=XuL2m4FZBWSdLOsCDaQeK9yYQbXFqo77cGWTFmH/OyA=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=plLqxkY3wYUNiCaJOTnz8rhMR4j2Ksg9fAyyQapLb1LQwznKtNmi+Bj6HK16Njrvjl4nnsu30FqFba9UDyL7Ca7bTGx9BaJIecjGAubeAD60zumndTUtSBa/wj8+tC7G0NrZKuktzxvn+3oAx0LbxBH9oQnLTOxTgZVxkc3UnOXNHTDOGqi1MXxiB6CZSoJnQ1XBP7k2i4K+lyS6ujKlhPdxpQPJPctrcLJjTKvGBU6iOkE/roc6sZS6lPnnXs1eAxkIB1/0bRQ8uxbwdqILMqUtJ3gOwdKK+yv2cS9bcS37wXs90/zZJqWYJjrl78ReVQrZq+c4k3w34eezkIpsyQ==
X-YMail-OSG: FnZZh0oVM1nJetmD2oR5zgotgF_2NzSrSmxf.Ok_cgNOe.NpkB6cMbIET0XEFkr
 1NgYmNBLhQ3_BKCLtygue4H7BvG0Bo4k7xQNdxltyFuJ021fMtiCntnMnwUBDpXu7Ep9z5ylBN2s
 Af9l_UBVdnjpekQrdKRuZGvocqWHi4lEdRLwhShNMG0r.NPm4UFWxShe_FRpBUF_HU6AlGMQWk8T
 nTpNPbhpni4QXd7k9x9a.L4F0aO90Y0hQCI79e5PmdXPhL8boeYr18SQmO5l8RyCepmCDM1BbiWe
 _IFJuhiJiEB7bWNPrOY3t8cDmTeKZ1zdTvU19Uc788CRX.bUw71gNSW3HHFDaT8HuwAwMqnSjvna
 __h5QX1ee3eMm2Mnn8cuEcsxjpxRd1qQJgOYgozIlL0a0cfRW9MxLq9qiMZXCsX4hSGpAM8O9bHW
 02XXh0nnu4COB29tKr5KUXD.PNjlYSHNgG.FQ42zifke36my8vkm5XUVYLY2m_rIAFSSp3.bKAK7
 ih8Aw84h_xkvAbSmcnOAf0H5qfVfH4XskuY9L1mYLr6zkzd.1wl1b2UtYGw1mYo7c_qSx8qmY2Y3
 SAmh.rHYgUcPc2Pk.790SuWHO3bjsRm8ZpmUn9h8JrYYJph3zOd4mQ.3hGTVjno_vJJfcUZp9zup
 n9inMMBEUs5cIQeAxHPToe4CIXPPMqkajbcqqom5nzcDAFF6nb7Lk2XUWfsSTm_BbzOICikrknsZ
 HIHlL9mnc6mxlmrMD8zfMDvHie12lHqPadBLQ8AI.cbOap48qHaeADv9u7zPFAHLdmzkiJy7Nvgq
 h6rwZyHW_XoSJED5WRndROZKBvtAWP8kmD5su1Z2f0cPIXLFZf1A_cxVwgMbDCPgQFoE.AXSBrSr
 tjhsk4GcT2E9le73QLvysFy9qJWEVfcjAw_SAJaMYW38ez7CyJp1nmdEBNoytRP0tbJ90EMA6n23
 GiF1BqToD0mg_igsYLMKli_fQyRaWhzRgI6HPsb3V4kraSSKBbtrvnLJooYzv4jGyRai25tn0IN4
 g0W4R9HbBE2NWsdzr7h0VqeJut7OdfdmCxgc3VxkeykWLIJofEaxvfrJpcJfeBcP4kRSqz_Juv.3
 TDQ2Bv5MH9AkbfkozDRJJ9rkh_k_5ttuhkQFO0gLHlifHKLbhdA.71k18dyaIiV0w5JiqQQjyJ9j
 8F5f2g_HOg3Cp4BYRfpnq5aTJhjbWTWUqul0YFb35u9fdaJsG3CHtABfBaOKzzS6ZOD8zAOfLdUN
 kFiD9gCBorbI3F5JzyJBkqt3T3hUOeu5PGB_g5S9wAbzHhrUif2NEI0A7rvfpI0ibMlCXs8Gv.TL
 mVkKk.U0QjHs1bsEUPJdi7mEoYhVjnC3KjcfDZImKy43.L63gdxZqMFpdy5v1IScIo6O42jPIDf3
 OUNO4zYnJp._lTrysGe5gJvbCzLI4ujucc3tMUB7ObA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Mon, 29 Jun 2020 00:33:22 +0000
Received: by smtp412.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID fdd7972e8918a7a5fd0af9d91b51c528;
          Mon, 29 Jun 2020 00:33:19 +0000 (UTC)
Date:   Mon, 29 Jun 2020 08:33:13 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 4.19.y] erofs: fix partially uninitialized misuse in
 z_erofs_onlinepage_fixup
Message-ID: <20200629003309.GA27377@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20200625051939.32454-1-hsiangkao.ref@aol.com>
 <20200625051939.32454-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625051939.32454-1-hsiangkao@aol.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16138 hermes_aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha

On Thu, Jun 25, 2020 at 01:19:39PM +0800, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> commit 3c597282887fd55181578996dca52ce697d985a5 upstream.
> 
> Hongyu reported "id != index" in z_erofs_onlinepage_fixup() with
> specific aarch64 environment easily, which wasn't shown before.
> 
> After digging into that, I found that high 32 bits of page->private
> was set to 0xaaaaaaaa rather than 0 (due to z_erofs_onlinepage_init
> behavior with specific compiler options). Actually we only use low
> 32 bits to keep the page information since page->private is only 4
> bytes on most 32-bit platforms. However z_erofs_onlinepage_fixup()
> uses the upper 32 bits by mistake.
> 
> Let's fix it now.
> 
> Reported-and-tested-by: Hongyu Jin <hongyu.jin@unisoc.com>
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable@vger.kernel.org> # 4.19+
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Link: https://lore.kernel.org/r/20200618234349.22553-1-hsiangkao@aol.com
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> This fix has been merged into Linus's tree just now (today).
> Since the patch could not directly be applied to 4.19, manually handle this.

Could this patch be applied to all next version stable
versions (4.19, 5.4 as well as 5.7) after 5.8-rc3 is out...

It's some important fix on specific compiler options
and should be fixed ASAP.

Without this patch, unexpected behaviors would happen
conditionally and break the filesystem from working.
Apart from 4.19 patch, both 5.4 and 5.7 patches are
quite trivial ones (can be cherry-picked directly).

Could kindly consider this and it's just a little
heads-up... Sorry for the noise if it's already in queue...
Thanks!

Thanks,
Gao Xiang

