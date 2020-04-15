Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AE31A99BE
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 11:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408494AbgDOJ6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 05:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405824AbgDOJ6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 05:58:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0229206D9;
        Wed, 15 Apr 2020 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586944701;
        bh=zRLH7MjMpAfYGE4tZVxlznjshcG5jJsz/QumxJXmOZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iBFyHGBNrWfsx6SQrsmCGB+ohd1LlXL3aBYn1nIDgJHFHFOz+zFM+R3b/Xusgpklj
         OWBgtKfDkRPef1uHWCw+V2ZzQ/AhuAmDZgCWwlFWlyNFQrtIJKQGdbZgtvci1CiUXZ
         9JuPovJNRJIBAhclDXj2DrUb7i1Ie8ivKL5J9Pe0=
Date:   Wed, 15 Apr 2020 11:58:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases
Message-ID: <20200415095819.GC2568572@kroah.com>
References: <20200415003148.GA114493@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415003148.GA114493@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 05:31:48PM -0700, Guenter Roeck wrote:
> Upstream commit e78c38f6bdd9 ("futex: futex_wake_op, do not fail on invalid op")
>     Fixes: 30d6e0a4190d ("futex: Remove duplicated code and fix undefined behaviour")
>     in linux-4.4.y: 177a981885cf
>     Applies to:
>         v4.4.y

Now queued up.
