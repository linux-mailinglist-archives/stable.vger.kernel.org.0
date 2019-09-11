Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67ABAF8AD
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfIKJQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfIKJQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:16:34 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E47CD2067B;
        Wed, 11 Sep 2019 09:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568193394;
        bh=bL2bn3vSHkQceyQjEuCXTqcdXpStvVCJCxI61V5Eh00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1Ky3x4L06AqmaayOdjd+FlawXIaAwpk8g7/zDr03h7y/c4oOMShcnsBxPpYWTQhX
         Mzw67KE10aYnGvBqWdkTh0IvIaJC+G77mGGoIaLmYUFfCS08uTBSddFXhzilqLw8/I
         D3FmqmAbRzkUtciadiA2CckyrLtGTY+Rc1cZIM4M=
Date:   Wed, 11 Sep 2019 05:16:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     stable@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 4.14] vhost/test: fix build for vhost test
Message-ID: <20190911091631.GI2012@sasha-vm>
References: <20190911025055.26774-1-tiwei.bie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190911025055.26774-1-tiwei.bie@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 10:50:55AM +0800, Tiwei Bie wrote:
>commit 264b563b8675771834419057cbe076c1a41fb666 upstream.
>
>Since vhost_exceeds_weight() was introduced, callers need to specify
>the packet weight and byte weight in vhost_dev_init(). Note that, the
>packet weight isn't counted in this patch to keep the original behavior
>unchanged.
>
>Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
>Cc: stable@vger.kernel.org
>Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>Acked-by: Jason Wang <jasowang@redhat.com>

I've queued it up for 4.14, 4.9, and 4.4. Thank you.

--
Thanks,
Sasha
