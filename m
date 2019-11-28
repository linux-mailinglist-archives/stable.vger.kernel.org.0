Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1120710C457
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 08:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfK1Hhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 02:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfK1Hhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 02:37:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 769132168B;
        Thu, 28 Nov 2019 07:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574926670;
        bh=77cMOKsXBQMMecKqy5G2EsrqX+nrH4DuZpn9tkXsHmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cr5mWuBXxSUpFIbXdhOaYa7VMXepQX7G/Qww1Umjhxc61CK0vCFIQbiD5i3Srw3Td
         5ZL505YKKsDrr1OWO9R4MsD+P4F+Q8Sbyi8O8iqd7y8Wrtr8DWVeAGus+O0fi9G46S
         Z4mfV84Oat3Ab1ZOLuDINqET7Np2d4RhDAl5C2/w=
Date:   Thu, 28 Nov 2019 08:33:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     suwan.kim027@gmail.com, dan.carpenter@oracle.com, lkp@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usbip: Fix uninitialized symbol 'nents'
 in" failed to apply to 4.4-stable tree
Message-ID: <20191128073302.GB3317872@kroah.com>
References: <157488438219127@kroah.com>
 <2087e46b-34dd-2a68-842a-13091ad66153@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2087e46b-34dd-2a68-842a-13091ad66153@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 04:33:15PM -0700, Shuah Khan wrote:
> On 11/27/19 12:53 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> This patch isn't applicable to 4.4 and 4.9. We can ignore the failure.

Ah, thanks, my scripts got confused with some of the backports that had
gone to those trees.

greg k-h
