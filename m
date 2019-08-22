Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F69D99981
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 18:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390152AbfHVQoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 12:44:14 -0400
Received: from sonic312-30.consmr.mail.gq1.yahoo.com ([98.137.69.211]:44654
        "EHLO sonic312-30.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731384AbfHVQoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 12:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566492253; bh=NqtxCPuufzLISW8B2ysYdhaSCNiOJN3WV3ux4y5AJPM=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=mjgPwxKpg6kj6UJoU0rSkC0t4ZYxEPIpoGYHpkmkJdUrA/DsWb79y26oVWM7KQm/+FUXseSo8a7xVS69OG5gPIx7DnL9yxJb5sQLUz4+9R5ncL+B+8MFSMznK+wnHzXhneK94rhGaIlXUr1Q8rfnCxaNVoZlCTF64zM1VeMAX3DuKA7DAUXKjpyJ8Lq2kFjxsvGKvCAOOy4KmhM3de6ohsZJUIdY7cbrY5Rhs8TkJN0JvuP9LwsDnT3nldN4JS8xTg+b8KLLTrNNROhVfPGnu90tZkPBYts+d1TJMfqYsBzmtO7sTbuLYrj8Fr6yAuUMfjqIeUWiBWiMxfA76Iww3A==
X-YMail-OSG: rXX1QYkVM1ll0el.otn8c5g_OqRTptrTy7CwThjsGFISlDkGud1PwRUj98Plst6
 1DlixBs4Atqn6tkoqXUgbaPgiY0tnh1Umjaid_erFpYupRBLd72jDvs7byWQBXC2rLTevT.zBmS.
 a.lRGL7fO9Kg3x69SKdGTnyRXjbd6u6rpsUxA.553R2YSb_hJ637WJMCWpLHaeAhTs4pnV4yjE0e
 sIYl8kCVLxFCk3bOARr1TxX7oUL1YMgYALoPmcVvobWMsu6AluLUT.lxWy3JaY9LWmmI9L2tFVhX
 Df0r9CKIW5iU6LEAEYTfFIApWKpJ4L8i8UA.0MDfH5A.TsZRgHZfUno12We_KcovAy075IWEGI.i
 pEViCk6teh9X3_vy_TxlFVyjbT0P2T_2DZfMxcrwkKOr3KNr4qkSaslRGoVuYJqkadCOtBJjbc6E
 8v0qXwmO4Q.h15LZj3TexwqFBWAQ541Gfq3wQLKF62WwAku9N0S78axYqJAVjlBb_nzML04UD4lX
 6BqqqAMwNBmldkaT.Zmj7xmksQ_wUs7Hk6sZNUcg_hw2tPyPeD3.91yg.nYcuLthPBRyOHdXPQXZ
 9paS3V5BYDMD7Az1rK1C83fdGYillRSlQyShVMPClgMZaoP.x8wWldKgpS6apF9DbXDYYqbpxrWC
 65DkJmOx9i0ikocv01XUbDeRtoWRMUJRq8Lh9UuKimBDNGyfCecywI_MTTTvuCn7Z8HTwRtPJaE5
 oCidK.43nnz45mIYo0l_eEY.lYwhItUL.2UOfSjgqI.o7EQvX76dNQDmgLg7YeZwGBw_.l4roStC
 RCM9HhQfQiUi4tC7Ro2dJ5PvkCeEOEipQP4VHq64uAqINWkUrZOMp7rKqboZRXogiSND1iP0QSns
 3WPwdp6CXL7sTy4n4iJ5P7zZxOaunycYMfSpmJMmEKiYvOfK5hhsq7hHjyeFGh_yjjOrV3puiNGw
 ThiZ2.Cp2eOkpfW3dFc.vXyXxUswr0rZS.ctyhXBYfdslj2.pixDV19mr1j3569F8gQwfhma_R.j
 NLGhjcxtHQSAGfY0hmqfzYvgVIBedyRyM1GPQhrkln9eUGBQG3mXbx._29DM3Z.9pqbS2F2lcjGS
 SA7ClL0w0TX_f.93ulTCBiXxJBbGNfnL36.jQ8XGXgYOw3WzpAFQeoCzEQclz2dRXPpMNq6eyFB9
 19Iipt4mc4LdKbmxkQC9OE8KWzc_WB_rP60evhLYaYgbONUI7.QEasZcfZQefP2qG02wZZU_KJw8
 2rIgsfUZteAmMw9fDm6mTfMY4iv_D.teMa0.lOlcEOLev8mkJ8nbMbfT4gauTgcvecvs67_QeEad
 FWpbSet2bAZgi1qtAU7l_pOul8dI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Aug 2019 16:44:13 +0000
Received: by smtp410.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 0b7cdfc00a2384b0a8f0646ddd1e4acf;
          Thu, 22 Aug 2019 16:44:12 +0000 (UTC)
Subject: Re: [PATCH] smack: use GFP_NOFS while holding inode_smack::smk_lock
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-security-module@vger.kernel.org
Cc:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+0eefc1e06a77d327a056@syzkaller.appspotmail.com,
        stable@vger.kernel.org, casey@schaufler-ca.com
References: <CACT4Y+aGjkmq4cEaQXagd_YqjE4a1HoNgcEzqeNj-g0Hg_hQHw@mail.gmail.com>
 <20190822055441.20569-1-ebiggers@kernel.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <1406434e-46f4-b80d-b3e9-1c6b05f82c14@schaufler-ca.com>
Date:   Thu, 22 Aug 2019 09:44:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822055441.20569-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/21/2019 10:54 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> inode_smack::smk_lock is taken during smack_d_instantiate(), which is
> called during a filesystem transaction when creating a file on ext4.
> Therefore to avoid a deadlock, all code that takes this lock must use
> GFP_NOFS, to prevent memory reclaim from waiting for the filesystem
> transaction to complete.
>
> Reported-by: syzbot+0eefc1e06a77d327a056@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

I will run tests on this, and will take it in the Smack tree
unless there are unexpected failures.

> ---
>  security/smack/smack_access.c | 6 +++---
>  security/smack/smack_lsm.c    | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index f1c93a7be9ec..38ac3da4e791 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -465,7 +465,7 @@ char *smk_parse_smack(const char *string, int len)
>  	if (i == 0 || i >= SMK_LONGLABEL)
>  		return ERR_PTR(-EINVAL);
>  
> -	smack = kzalloc(i + 1, GFP_KERNEL);
> +	smack = kzalloc(i + 1, GFP_NOFS);
>  	if (smack == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -500,7 +500,7 @@ int smk_netlbl_mls(int level, char *catset, struct netlbl_lsm_secattr *sap,
>  			if ((m & *cp) == 0)
>  				continue;
>  			rc = netlbl_catmap_setbit(&sap->attr.mls.cat,
> -						  cat, GFP_KERNEL);
> +						  cat, GFP_NOFS);
>  			if (rc < 0) {
>  				netlbl_catmap_free(sap->attr.mls.cat);
>  				return rc;
> @@ -536,7 +536,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  	if (skp != NULL)
>  		goto freeout;
>  
> -	skp = kzalloc(sizeof(*skp), GFP_KERNEL);
> +	skp = kzalloc(sizeof(*skp), GFP_NOFS);
>  	if (skp == NULL) {
>  		skp = ERR_PTR(-ENOMEM);
>  		goto freeout;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 50c536cad85b..7e4d3145a018 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -288,7 +288,7 @@ static struct smack_known *smk_fetch(const char *name, struct inode *ip,
>  	if (!(ip->i_opflags & IOP_XATTR))
>  		return ERR_PTR(-EOPNOTSUPP);
>  
> -	buffer = kzalloc(SMK_LONGLABEL, GFP_KERNEL);
> +	buffer = kzalloc(SMK_LONGLABEL, GFP_NOFS);
>  	if (buffer == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
