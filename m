Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F54B2841
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 15:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244691AbiBKOtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 09:49:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbiBKOtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 09:49:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67922131;
        Fri, 11 Feb 2022 06:49:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F9BB829EF;
        Fri, 11 Feb 2022 14:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AE1C340E9;
        Fri, 11 Feb 2022 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644590961;
        bh=+DQpPUN4Bcf1ej2vYBc36zrvPwUquP8zQokxW8PxNhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1Xr0a8bW0cxPM+jB1fWoCyOY6XT2f7HGH+q2pxWkPX2QQFz/dmRWghShxN4JITkT
         snJT7+HAOZ3Fr3qHkvWsvMkiHiAcIFUQv1AWrzxugRnEKlGSJZJF7X/lABPAEU/Tee
         jpUpPr9QYIZ5jD451lsNhw44UuOrOuJVu08FtTwQqpF8LtWJsFraX8cUedCbpJzsaZ
         /EjYHYKI9x00Oa+qaT8banoX71LU2l8xvjG70vSaVQPa6RjSThAu/B+/TQ+aE4lapC
         VAqw8noXhiU2MeIFst/ZAWPhb6oR2la3WXcLroaYImQsfkPAGYRGLN9pqWoC1r3SUX
         9SfgzSIznnmRw==
Date:   Fri, 11 Feb 2022 09:49:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        trond.myklebust@hammerspace.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 5/7] NFSv4 expose nfs_parse_server_name
 function
Message-ID: <YgZ3cPY6l5qp3D6G@sashalap>
References: <20220203203651.5158-1-sashal@kernel.org>
 <20220203203651.5158-5-sashal@kernel.org>
 <20220206221907.GA26066@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220206221907.GA26066@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 06, 2022 at 11:19:08PM +0100, Pavel Machek wrote:
>Hi!
>
>> From: Olga Kornievskaia <kolga@netapp.com>
>>
>> [ Upstream commit f5b27cc6761e27ee6387a24df1a99ca77b360fea ]
>>
>> Make nfs_parse_server_name available outside of nfs4namespace.c.
>
>I don't think this makes sense for 4.9-stable. Noone uses the new
>export.

I'll drop it, thanks!

-- 
Thanks,
Sasha
