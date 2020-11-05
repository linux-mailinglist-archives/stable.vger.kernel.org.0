Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B716B2A7A1B
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 10:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgKEJKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 04:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730654AbgKEJKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 04:10:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FEDB2073A;
        Thu,  5 Nov 2020 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604567418;
        bh=a8sTekfjr0nJRpikj9vmG5dEHcq4ZEwBVRu4YDAjLog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E1ZmUSNEJRc5H3SznaVBJNofKl2LFts6N9qUWYbH0ppsVvKszYEJM3auYwSW67qHq
         znVoX8zcx2ChUccDXdYlgzcLIJN8p4IiSMGRgUN6ffcr0IQSL8y0rMNkE9FQVFXNgs
         1j9ZHCbE/kIl1Q1pvkHgTEpU8ooGi2sNtoGShlmY=
Date:   Thu, 5 Nov 2020 10:11:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Linux 5.9.4
Message-ID: <20201105091106.GA3435672@kroah.com>
References: <16045237196633@kroah.com>
 <16045237193961@kroah.com>
 <13da09e2-9692-f2f5-7a55-d949f1f9a6de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13da09e2-9692-f2f5-7a55-d949f1f9a6de@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 09:34:32AM +0100, François Valenduc wrote:
> I find this strange. There is only 4 commits in git between 5.9.3 and 5.9.4
> while the review had 391 patches. Is it normal ?

Did you read the email before this in the series explaining what this
release was for?  :)

The "next" release should have all 391 patches, give me time to catch
up...

thanks,

greg k-h
