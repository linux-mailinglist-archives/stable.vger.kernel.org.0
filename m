Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1D36A028
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 03:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbfGPBNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 21:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfGPBNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 21:13:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B7F20665;
        Tue, 16 Jul 2019 01:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563239589;
        bh=nbRBF+KsFrIEEMx5I2n7Ec5vYWMYUWN5t0dtndYQLis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XYdmPcirFmP7TqaiRoxw2DYfPWS2mWLirejRxGzEcLq2DvR5ShlJ4zrffEbNVZN7g
         R+q422gJcI64MlyKVixsSk5UwI+7h0tAJ51SLWp81gveGhWEcQyiRgftrxo5m2u7rC
         5BO7SmiXc8S/reEH0SGnv2tnvUGrpyX1aYmHUtq4=
Date:   Mon, 15 Jul 2019 21:13:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>
Subject: Re: [v4.14.y PATCH 0/2] fix drm/udl use-after-free error
Message-ID: <20190716011308.GA1943@sasha-vm>
References: <20190715193618.24578-1-zwisler@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190715193618.24578-1-zwisler@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 01:36:16PM -0600, Ross Zwisler wrote:
>This patch is the second in this series, and requires the first patch as
>a dependency.  This series apples cleanly to v4.14.133.

Hm, we don't need ac3b35f11a06 here? Why not? I'd love to document that
with the backport.

--
Thanks,
Sasha
