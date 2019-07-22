Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BD270268
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 16:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfGVOfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 10:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfGVOfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 10:35:32 -0400
Received: from localhost (unknown [167.220.2.219])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E211B218C9;
        Mon, 22 Jul 2019 14:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563806131;
        bh=sIeNn7wKci1PAu/7W4jXe03dA9c3fLzBr+9SQG3KNv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SszaQ6es6SV7b154+jgxgtoaw91t3W436/hgWadma9VWeH4LrQFbh5yR2GY5yf9C/
         ThipGd16EMzYf1vo+XbKB2dlz6jGfc2qLuivfeZNQmdwmD0WxL+y8sUPJYg4VC8cJp
         BZ1rbmh+yAPVSa1lo0tLUeB7QDtVwXKjqPlPCvZ4=
Date:   Mon, 22 Jul 2019 10:35:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com, stable@vger.kernel.org,
        amir73il@gmail.com, hch@infradead.org, zlang@redhat.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190722143531.GG1607@sasha-vm>
References: <20190718230617.7439-1-mcgrof>
 <20190719193032.11096-1-mcgrof@kernel.org>
 <20190719212300.GQ30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190719212300.GQ30113@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 09:23:00PM +0000, Luis Chamberlain wrote:
>On Fri, Jul 19, 2019 at 07:30:32PM +0000, Luis Chamberlain wrote:
>> From: Brian Foster <bfoster@redhat.com>
>> [mcgrof: fixes kz#204223 ]
>
>Sorry, spoke too soon, although it helps... it actually still does not
>fix that exact issue. Fixing this will require a bit more work. You can
>ignore this patch for stable for now.

What about the other 9 patch series?

--
Thanks,
Sasha
