Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB3318697A
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgCPKxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 06:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbgCPKx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 06:53:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABFC2051A;
        Mon, 16 Mar 2020 10:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584356009;
        bh=eBB9d+s1Ia6M0wmpG1R/nd0F36p2cG+AgTHTE9+6xvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bo1G9tyYxX0NSYGyvfSJzitE1wz6QETFwI5eXPoAPYJL7iRw5Bmxc10r9qM7NyTw2
         +K0NI4z62zZNFA+IpTGQ7EL7G9tZJMhuXoWBr35teXiotyd98E04EsfKVxfZaH6E7Q
         iDCq0K82E0oyDovADH4Hrm5U0lxheW93xGb0Vt9c=
Date:   Mon, 16 Mar 2020 11:53:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yukuai3@huawei.com, alexander.deucher@amd.com, sashal@kernel.org
Subject: Re: [PATCH 4.4 035/113] drm/amdgpu: remove 4 set but not used
 variable in amdgpu_atombios_get_connector_info_from_object_table
Message-ID: <20200316105327.GA3509566@kroah.com>
References: <20200227132211.791484803@linuxfoundation.org>
 <20200227132217.325886959@linuxfoundation.org>
 <OSAPR01MB3667601BEAABB5AF95FB799592FC0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB3667601BEAABB5AF95FB799592FC0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 09:07:47AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi,
> 
> This commit has a issue with duplicate grph_obj_type declarations.
> And this has been fixed in commit:d785476c608c621b345dd9396e8b21e90375cb0.
> 
> ----
> commit d785476c608c621b345dd9396e8b21e90375cb0e
> Author: Colin Ian King <colin.king@canonical.com>
> Date:   Fri Nov 8 14:45:27 2019 +0000
> 
>     drm/amd/display: remove duplicated assignment to grph_obj_type
>     
>     Variable grph_obj_type is being assigned twice, one of these is
>     redundant so remove it.
>     
>     Addresses-Coverity: ("Evaluation order violation")
>     Signed-off-by: Colin Ian King <colin.king@canonical.com>
>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>                                                                                                                    
> ----
> 
> Please apply to all LTS without 3.16.y.

Now applied, thanks.

greg k-h
