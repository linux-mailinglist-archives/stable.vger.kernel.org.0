Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FF02E2552
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 08:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgLXHwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 02:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgLXHwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Dec 2020 02:52:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9431922571;
        Thu, 24 Dec 2020 07:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608796334;
        bh=9eKS2a24n3ah2NUYUfQZyOL28YxIK5fS3TLu55pkzwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TRiJhvPEO8Y93Iss2HhOhxZiYHs1ieWAKfkltW+LRrujMoXAb7kYLtotY3QfMfh/u
         j396ddo2vzZ1wJwIldLlQmra/5l1spKvLqTA8LkYqa05cYt06LLLfJ5Irf6U1ozfQ7
         1qJSb88zZGE26a+zk6OXPic0rZWTR+vbcfkY6KXM=
Date:   Thu, 24 Dec 2020 08:52:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kitestramuort <kitestramuort@autistici.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.10 24/40] f2fs: fix to seek incorrect data offset in
 inline data file
Message-ID: <X+RIq1wk1ZBPIxsX@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <20201223150516.715040953@linuxfoundation.org>
 <962b2db7-383f-b4da-5221-2004235d19c1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962b2db7-383f-b4da-5221-2004235d19c1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 24, 2020 at 09:11:53AM +0800, Chao Yu wrote:
> Hi Greg,
> 
> Thanks a lot for helping to resend and merge the patch. :)

Not a problem, glad to help out.  In the future, all you need to do is
give us the git commit id that needs to be backported if it applies
cleanly, no need to send the whole patch!

thanks,

greg k-h
