Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13A0248FED
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 23:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgHRVIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 17:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgHRVIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 17:08:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9BA20786;
        Tue, 18 Aug 2020 21:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597784917;
        bh=WtAGDq3XNqb/mNa1w/YUxy/uy62/Xy43xlNRgLNL1qY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wDqUqHVRIx4KwZa5mdndk87xJisWf6cBffZkq6huYpkc0ORKsRLx5FRppqt6O22le
         gAaeTVejQUpYx33lvpZZFuylNmNEmhjgmRFFjmfIy1ksOmOaxLAQU1Myjsvics+fBE
         IOqXY4eslq7CrKxmLA4hxjLk0ng0Ushnvz0yTalg=
Date:   Tue, 18 Aug 2020 17:08:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: thermal: ti-soc-thermal: Fix reversed condition in
 ti_thermal_expose_sensor()
Message-ID: <20200818210835.GH4122976@sasha-vm>
References: <CAHCN7x+Y52_cpJgRe9nSJYMXfHFkggrjgriMgtfqw9=CQ2Qyvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHCN7x+Y52_cpJgRe9nSJYMXfHFkggrjgriMgtfqw9=CQ2Qyvw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 01:25:03PM -0500, Adam Ford wrote:
>Commit 0f348db01fdf ("thermal: ti-soc-thermal: Fix reversed condition
>in ti_thermal_expose_sensor()")  Fixes an issue that was introduced by
>accidentally inverting the check which disabled the functionality.
>
>The issue was then backported to 4.14+ kernels, so they are also
>affected and this patch fixes the regressions.
>
>Please backport this fix to kernels 4.14+ to restore functionality.

Already done, it should be in the kernels released ~tomorrow.

-- 
Thanks,
Sasha
