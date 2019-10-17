Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D1ADB5A0
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395528AbfJQSLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395229AbfJQSLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 14:11:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E0E21835;
        Thu, 17 Oct 2019 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571335889;
        bh=q4wTAlyVFBhPMRS0AB+M0djN9O6RVkiuHL493TiXn28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMNKsL10d0wYLvLCwl+zGhPNo+VMVQ8sotsWc4e0N8j09l5HYpQkH00OJf1rI/yLw
         yO3TPAMESMp6FMLiejKCy7OqjhKBji0QnIxPT/JpFQxrPT0y4cUO80u0qzU21mSsbK
         Zsb103jKDHBUwxgsD0Q12FmvntZPRsdVqtTsFnjg=
Date:   Thu, 17 Oct 2019 14:11:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Cc:     "jic23@kernel.org" <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
Message-ID: <20191017181128.GX31224@sasha-vm>
References: <20191016144253.24554-1-jmaneyrol@invensense.com>
 <20191017143142.489CF21848@mail.kernel.org>
 <MN2PR12MB3373BC1DE5152A4546940EB3C46D0@MN2PR12MB3373.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MN2PR12MB3373BC1DE5152A4546940EB3C46D0@MN2PR12MB3373.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 02:43:55PM +0000, Jean-Baptiste Maneyrol wrote:
>Hello Sacha,
>
>I can do a specific patch for backporting to kernel 4.19 and older ones if needed.
>This is really simple.
>
>Tell me if this is OK for you and how to proceed.

If you do end up doing a backport, just send it either as a reply to
this mail, or add a "4.19" tag and send it over to
stable@vger.kernel.org.

-- 
Thanks,
Sasha
