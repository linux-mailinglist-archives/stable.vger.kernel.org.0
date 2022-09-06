Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B3D5AF6BB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiIFVZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIFVZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:25:56 -0400
Received: from sonic306-28.consmr.mail.ne1.yahoo.com (sonic306-28.consmr.mail.ne1.yahoo.com [66.163.189.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F419D8EB
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1662499554; bh=qbYWQDebdKRJlSHglYHzK/lYxuJTssieTquIXMiJqDs=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=IpuK3K2aMK7ACIZsydS+8c1OLn/Cq3fQrwIyqz7mOWVB0+rgkEiq6reXFxZ59RYiX8Das3tH6QoCVbtGQMNVv+1s4J8YT44xWMMh64l3RH/+aTCAv+CTyyJ7S0oG1NaH6d1RoBi2AY1Qk4ajXzcJRYoFCYtbCTv3He5k5tFErwSWNIr9nwJ9KcK38ZxVMDJ+clytd/BgmWwGg7oXYV3ChVVlixwo15ji4zO+DpFIcBxT9Gs54B2qs+iXzR9byA6i33ELzZCfODCeXEhfPa5unU5Bf75khxC29hQo73TZlp6Mt+nNwiU3CAfLWDuUptwe8pN0P6ZIOAbDS6ajRkdp3Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1662499554; bh=SWg/MpF2G3YeG2aX8u62mCrMfojj/zhDE72YyCvBBQ1=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=My1Rph3yd03h7dsGSEEzfY2DWxTL0vGZeu5ytBG+dMVHnkFZQTdrg8fLCTCjVW6SuX1ROJq/5jfZ4dGauvEi82CsqMwIeGMICSLWHQH8PiM0XGIEyBuA7gEOVvYT5QjON//LRbp2PDj6hHC6/7IxlIuiuQzT9jIrvUJW0oziKy7QTaAiaX1KFVfEarl2I7MCSWGTsHs4jH8J6PVd6SM/QECvsR25zuSKxr1uOf8P/WVNoAo6OiByQDNhMMzkPgnkUxVKVq58t9G5uBEQi+f8eExtRzb4ilTArOX87TdWZ3vrDEeTbP0Puedx8SUcDKZRI3DRDnNUjXCTZ7ayligBIg==
X-YMail-OSG: 5CZOJfAVM1k2WnEbX0x_0psYp7QfGw9zMxUAJ0a_qC18eCPYRiUAtDLetHhM0f2
 WgbR6o0EfiKLy1_pJuZNxdSPtOERXT6sKv96M4qF18K1lsvaHM42CiwS6NPbmMLL2BpbM038v2eA
 1rpqioHAHkrU6cAv0k4eHz4MzahDZ8g41Qh6hrAKZNdbvJiVmtJWvdbN1D7Enu4GAoYgNtXDyyFG
 tlSeRr9yyid8xmYVMiu1rhXYG.NpS4XYQHaF1kZVhZMeTssQsYJRnYBEkASxEBIDPuaU6udyeEjp
 W7LiwKPPuA2_UPNiD619eZQYsDYcDFSd4mnTGzNOwQm4n4rC0kOHpUvo0CYjglH5bbqBdzrDwR4v
 PriH.EKGjp5duPfx0ZFSvSc7Hg4ubE9nX25asHtPZbQWCnB.lyNsZ5pUuHdnkYVZQyxWD4TROnom
 O4h7iLk3FbXXOK2qkkeHaV6HABoNh7vkp_Gypw9n_Lkq15JjX25ObOTerOpAllrw9jghskU9NCZ0
 G2JVImiZaLxcnq97MCxG9.3hFvuhioQMn1009UcGvgruHeMzv4c8QrrBU6Pv99bZZBa7sEPbNv_7
 A0attKJfzygfCsPbRMnWiNe42VzNHmJoVxjldS2tFoV5Qj0qJyNCDjvdn2pFouKmDy2_sHgmQper
 97xpFaXodDP6OrrSx.T8vQ3bS46H3stFN4odEKLD5vPN5zPiMYx7cuAhMutIniOsqfhHZ1GBxqoy
 lVibE05WRkjRZGWjrWZHfZJdpXy6b2UZuMsMvRm4CwQe9kc1oHI1KFzl6z5CYetKql2cs5ObvwJ3
 gaPc0.nDBt7FjLSiK5R0uVkcN7tzA.lriLrFVGwxIiaUZvd3CuHKFY_MlHtG5cs_j3fscc8ZEElB
 JTfx.uHwTFvHvnj.og_Z6hjRlQRKHGgGiF6iePlVOzjOeoKHAxev3hTa6U3FurJxz99XlcTkSmG6
 g75goKZ6i59hsM5szDmiT7JMRSU8tF7ECDDDcXXN1pX8PCkuxVenI0_vY_Wds0r71cmJwsBgQbA2
 qCXUcnbQaAhJLLHQh.hqBf.pkbTLxlBBA8aocDTIQVygtZzUVk8qaJnKCp1q9o.izDx_pYH34vF.
 _xpp7sMNhUPS8XBVlOFK6JQmrRoiiVNcwQXvr8CmoE28Q9rq0T2z_5JDM7RWpxe9DRGFZBCtgRU4
 96jsXWgQzsQbcvhJJgSr2burEhxjfL.Owz7zxx9sRiavBvnCBHb3.4XdNrHSyrAGHZgrI0MUIgxl
 lkGsMKHa_dHvnBtp0fOV690msIaJrrtRyN3cd979R8YYZ08Kegq0e.XHyHrCiBNqrj7G9VVj2rSC
 TqJZtURc59RtfKWXjtYSry_lPvSx8ohMB7bcFLU.P7rsLsGDJO4kjut1TvV6EvF_EnxRNlkyrzNC
 CRE3hks.xfDhG743VOOq9OTtYGZ6A62rvTDVD3FePfV.dnkADONYUeGiulFKEbJJ3FHCxq8nLgX5
 vHhqCYqsw3oaiN2ij_4FtEsbipYXAdUZKN_riWTKfESSFkF0x_4PBQJJXjjyrVJtnDN2T8xfZMqy
 HaGbTMowVql0owD4E7.509gi2_.hFqRaYWskZg9GgHi3an5OWCtchCiWvsaGv4xa0NFn_Zn3D1TI
 tVMgeCIu3kDWqj_WnadaBQidbnpBs5whWcuYTIRDgWw339evS12XUo5ECl_I71R3dJiGpcVuQh_8
 0lZRqIh4hj2aNYjUeZ1O0bzIwyX2BX8YVFhoY8Q6V0ltfnKp4zbWuicb8nmyAyMzsArHvQ7NEsSk
 farc0ZcepiOYdfrjJNNdVqSbQgnWfrrEoVEzdv7AHmzcR0RQzS6MWclmSoJkzrIaw9U1ylpiwt0x
 bw0aMKDaYdkjPQY.wElsAipWdUtN4tXchO0UkmtP7YHWFhgad7aH9_MvriQpv6FLkjSHxrx.65Tm
 g66Uxs6Z1C5ZBN9Tz4a7xxsHLDTq7d9UwjymNu1d4.jnSExY_EpPYblJBA2A8S7iu5f_Kml67Cy4
 td.iDeqx7wQ5qIDkJjp7NfKXoYvcBK09Duoy8hxR_I5GcYh7VgaWN.wtyLe6vQUhVL_0o3Xwwx_w
 yxa30Nkt0_kanMC2hcbjqJ_Zo.4ARPOdebSSfwhbwW.iPpvg7iSs_CoqultgHzVexewg.KXZ4m3n
 gh8yBoK0TTIeKuN5ia.ZSgAS9kw8VMQiSJtCsKjTyAwkYk3DK5mO2ZfkffTo_Sfk14q2CnQgSog8
 xA1jeyAOSXabPtTmcsn0l_jCYe2fpaOiSyxeJkhJglEq3SZAXN_H_I.t2JmSOJ96ZEMIsLGsnxjE
 cBOT09URERJtG
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 6 Sep 2022 21:25:54 +0000
Received: by hermes--production-ne1-544744cc75-mbjj6 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID e23b1e41a6d30c0e8282d8192ffa35bc;
          Tue, 06 Sep 2022 21:25:49 +0000 (UTC)
Message-ID: <c43c2289-71ad-2afa-fa5d-04e1276cfc47@schaufler-ca.com>
Date:   Tue, 6 Sep 2022 14:25:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [v5.19.y PATCH 3/3] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org
References: <166249766105.409408.12118839467847524983.stgit@olly>
 <166249823441.409408.621539815259290208.stgit@olly>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <166249823441.409408.621539815259290208.stgit@olly>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20612 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/2022 2:03 PM, Paul Moore wrote:
> Backport the following upstream commit into Linux v5.19.y:
>
>     commit dd9373402280cf4715fdc8fd5070f7d039e43511
>     Author: Casey Schaufler <casey@schaufler-ca.com>
>     Date:   Tue Aug 23 16:46:18 2022 -0700
>
>     Smack: Provide read control for io_uring_cmd
>
>     Limit io_uring "cmd" options to files for which the caller has
>     Smack read access. There may be cases where the cmd option may
>     be closer to a write access than a read, but there is no way
>     to make that determination.
>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  security/smack/smack_lsm.c |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 6207762dbdb1..b30e20f64471 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -42,6 +42,7 @@
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
>  #include <linux/watch_queue.h>
> +#include <linux/io_uring.h>
>  #include "smack.h"
>  
>  #define TRANS_TRUE	"TRUE"
> @@ -4739,6 +4740,36 @@ static int smack_uring_sqpoll(void)
>  	return -EPERM;
>  }
>  
> +/**
> + * smack_uring_cmd - check on file operations for io_uring
> + * @ioucmd: the command in question
> + *
> + * Make a best guess about whether a io_uring "command" should
> + * be allowed. Use the same logic used for determining if the
> + * file could be opened for read in the absence of better criteria.
> + */
> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	struct file *file = ioucmd->file;
> +	struct smk_audit_info ad;
> +	struct task_smack *tsp;
> +	struct inode *inode;
> +	int rc;
> +
> +	if (!file)
> +		return -EINVAL;
> +
> +	tsp = smack_cred(file->f_cred);
> +	inode = file_inode(file);
> +
> +	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
> +	smk_ad_setfield_u_fs_path(&ad, file->f_path);
> +	rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
> +	rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
> +
> +	return rc;
> +}
> +
>  #endif /* CONFIG_IO_URING */
>  
>  struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
> @@ -4896,6 +4927,7 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
>  #ifdef CONFIG_IO_URING
>  	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
>  	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
> +	LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
>  #endif
>  };
>  
>
