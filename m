Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B9C43FC
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 00:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfJAWtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 18:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbfJAWtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 18:49:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB5621D81;
        Tue,  1 Oct 2019 22:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569970154;
        bh=xB9IwsMj/fScYg2XiwPqGatgL6Aty5pZqlqJ/wiTtZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KHsqcGBXq0Nawrs7C3od9Zz1F+ZC53m7bZEuO/J64qljqanzDioDLSARWOdEL3qf8
         nxq9cpsNNWVvQZTARDpUkjZPzahQb30Cld1mYuVG+yqCiIhpTbIOJHC2zVtsYEEfSo
         g53ifhLnU64BlLmk3ydnVHqn7BCXiZE0nDMwDwvY=
Date:   Tue, 1 Oct 2019 18:49:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven French <Steven.French@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: Re: [PATCH 5.2 02/45] smb3: fix unmount hang in open_shroot
Message-ID: <20191001224913.GE17454@sasha-vm>
References: <20190929135024.387033930@linuxfoundation.org>
 <20190929135025.151404151@linuxfoundation.org>
 <BY5PR21MB13958939EBDEB4122A29675EB69D0@BY5PR21MB1395.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BY5PR21MB13958939EBDEB4122A29675EB69D0@BY5PR21MB1395.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 08:41:43PM +0000, Pavel Shilovskiy wrote:
>Hi Greg,
>
>Are you going to apply this patch to the 5.3.y stable kernel? The patch is applicable there too.

I will, yes.

--
Thanks,
Sasha
