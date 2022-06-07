Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5235B53F592
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 07:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiFGFhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 01:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiFGFg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 01:36:59 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4BAB7DD8
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 22:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654580218; x=1686116218;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Zp8wQ7aBPkyLxl2Rb2FwirUvR1yawC3bsAhIP65z2rQ=;
  b=ZkF6laoQhE8+u9lKG1qRoQq8fqGL9yg0jP5fzZY+6qij76pBdVILHJPs
   POEq0EPc1aGc0Cr5WdyaGMbaZfwEp7Xe9ErY3lynvIHIe3V2lUfQWtZQd
   jeM51iwERkr9Qlbj3dlRl42/5uZCiuKZtIaJI3k32Zcfx/O2wW29RGzdB
   04vmwXGOgRZhciR1NId/8aDcMSfPgjR3ed+n2wYJcpUb1cbJwrNxVuLSI
   PVmidjB3fJKAMJSirQXFPSJ1MBYB7WMXNK1ohBIU1YqNzYBmN0wElvGkN
   aHcye3J6f5twoE9bQryhRBkj3iSEUG3+FPpD3ISqU3Y/rJ9lD8jy9aeYV
   w==;
X-IronPort-AV: E=Sophos;i="5.91,282,1647273600"; 
   d="scan'208";a="201183871"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 13:36:58 +0800
IronPort-SDR: t/oCQOdoqXJwHvosHNQ0HKsEzEVn5MISGLQxre1IMbKPFXsygQx1ahRqX+f/RaKH7jYOsXZF9H
 F6T1DFvAuvYYEV+tyWDwxwJBRXKm5F8dIyq6Ra0KdZ9ZJroEu51jgUyDi5bVKl4ZYIHCgoKr97
 J6ZMkz7aoZGRpm4NkIBG2yehowErGKuMme7UaXi8S1Q1GZ4f6eF9qsRsPHeLJbTjWi8NQq9ast
 PS1nDUBS/tn0AJG6nMrYjgk6CNthHhF9Qdw1BRV1IUwRo0mtmY/qcIMltqnbuNCIwqZhAi/lxD
 0auvYdc3XogeckpOuLu7s/MQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 22:00:15 -0700
IronPort-SDR: 5RP/pi1FtGGKx/vimd4Wa7disgICY50gohRjIi0m1Fh4tBh9aIzlMjzUiATesG2A3G9kdwOFbB
 BYFCSqsmVte6UZgw6Rzi3gl2cyJedWGC3vt92C38j4z0C4WO0lmi50YvPpNbDCC1iINnOelnTS
 EaRx8c4BZyNrOuXakY5UfcrbxVm2bFmi+XSlyPGFNdn3tvpULnVn5ulAa8X4wAqr5sIm/hxaMK
 nTttzCV6s79EOWRIv3ZodrRO1oh75uh1KuIXPdQbCH0bPKHpQJgHnBm4RrA5uF2qFNgwdL/3W+
 JHY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 22:36:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHJyL2gkTz1SVny
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 22:36:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654580217; x=1657172218; bh=Zp8wQ7aBPkyLxl2Rb2FwirUvR1yawC3bsAh
        IP65z2rQ=; b=m67IrweL+t9jTqfPT8ugr2D7W2pI4AovjkFchQTHEy00cWjErsf
        T68uLKt2AD+JUoRqaIY4PuZKwBeZSHUvRsRsWop+hRCd6VAthT6yNLxN78RZjIyg
        meL/5QBWW9i1sdeZPhx5w8sSj/4ScEVlVMH1gs8X69/XS5G9jPXIs0XXfX8ZxaS3
        mjmAXJxKf+0UyJRkp+x5QjgqlQfpmHdf0Fgsa2EsXi1V7lVYb8z1daPSti6I0kF0
        HttgIZ0G+S2/V12DB2sbn3KFfwKrUxvJwm5Rhtza0ovotyynjH/LXQ6bZKGjmsE4
        Ni/xVUxVExrvE6Lk9Yu2C7b7SczILHtSPSg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5k0FVUVdcBq3 for <stable@vger.kernel.org>;
        Mon,  6 Jun 2022 22:36:57 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHJyK1KS8z1Rvlc;
        Mon,  6 Jun 2022 22:36:57 -0700 (PDT)
Message-ID: <3f634bd0-c896-d9dd-a617-caab68ff025a@opensource.wdc.com>
Date:   Tue, 7 Jun 2022 14:36:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] zonefs: Clear inode information flags on
 inode creation" failed to apply to 5.18-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, hans.holmberg@wdc.com,
        johannes.thumshirn@wdc.com, kch@nvidia.com, stable@vger.kernel.org
References: <16545184941948@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <16545184941948@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/6/22 21:28, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Greg,

This patch is already applied to 5.18, 5.17, 5.15 and 5.10. I think that 
your bot picked it up again because of the bad PR I sent to Linus for 
5.19 which had these patches included again.

My apologies for the noise.

Thanks !

> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From b954ebba296bb2eb2e38322f17aaa6426934bd7e Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date: Tue, 12 Apr 2022 20:52:35 +0900
> Subject: [PATCH] zonefs: Clear inode information flags on inode creation
> 
> Ensure that the i_flags field of struct zonefs_inode_info is cleared to
> 0 when initializing a zone file inode, avoiding seeing the flag
> ZONEFS_ZONE_OPEN being incorrectly set.
> 
> Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 3614c7834007..75d8dabe0807 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1142,6 +1142,7 @@ static struct inode *zonefs_alloc_inode(struct super_block *sb)
>   	inode_init_once(&zi->i_vnode);
>   	mutex_init(&zi->i_truncate_mutex);
>   	zi->i_wr_refcnt = 0;
> +	zi->i_flags = 0;
>   
>   	return &zi->i_vnode;
>   }
> 


-- 
Damien Le Moal
Western Digital Research
