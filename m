Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A5E15F746
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbgBNUB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:01:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387401AbgBNUB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:01:58 -0500
Received: from localhost (unknown [12.246.51.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD3724676;
        Fri, 14 Feb 2020 20:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581710518;
        bh=NT3ypwYH6d51W/Tuba9GPtqMoCS+Y8u0pZMOJvivz9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jdFIlGqymfXtvWIxRQdJmPZzGIBQB+oDLNtZXDoP43NTJzGiEDgl1WSFPbW6h9HrT
         zt0h+lZl41CDFoHnvTaURGxAVYvqtECn6s6d93z3KhhspbS0/nCA7Fe1S7mRr2YuNJ
         LI27OUTYUODbM0SwFLRxAQZpMlaJfA6W2Y87Tjy8=
Date:   Fri, 14 Feb 2020 07:19:15 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cipher-hearts@riseup.net
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 4.14+ doesn't work on only board with open-source BIOS & without
 Spectre bugs
Message-ID: <20200214151915.GB3959278@kroah.com>
References: <20200214100655.pyljxoa5pkhagbct@localhost.0.0.1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214100655.pyljxoa5pkhagbct@localhost.0.0.1>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:06:55AM +0000, cipher-hearts@riseup.net wrote:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206257
> 
> Any suggestions?

Can you run 'git bisect' to find the problem commit?

thanks,

greg k-h
