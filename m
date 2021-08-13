Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CE83EB545
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbhHMMWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240455AbhHMMV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 08:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE0A60F00;
        Fri, 13 Aug 2021 12:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628857293;
        bh=ZhfFwXuesXGdt1/e9LvTpBXt1NX3V5RBx9BA1t8YokE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRq5Zy5Uip6yzubkgCW2cZ81zKdO9i2E1acrxf5FCOOyaetDKF+DRG/yP7fuunZJO
         7OQ733ZrPynBp4RLiMhI7Fksi4h0PV3OpGpf2R5QkwS1Gq1DjQpcWzs2X2HlWw17vj
         /Zec0jzaMVGu8KeZbcQas+NURDSYaFTkV6nqHaIY=
Date:   Fri, 13 Aug 2021 14:21:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 2/3] btrfs: export and rename qgroup_reserve_meta
Message-ID: <YRZjynr7gKodWEFC@kroah.com>
References: <cover.1628854236.git.anand.jain@oracle.com>
 <4cdae9f94a8feae8f848574c214016ae6a923078.1628854236.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cdae9f94a8feae8f848574c214016ae6a923078.1628854236.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 08:12:24PM +0800, Anand Jain wrote:
> From: Nikolay Borisov <nborisov@suse.com>
> 
> commit 80e9baed722c853056e0c5374f51524593cb1031 upstream
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
>  Conflicts:
> 	fs/btrfs/qgroup.h

What is with the conflicts lines?

I'll edit them out, but be more careful next time please...
