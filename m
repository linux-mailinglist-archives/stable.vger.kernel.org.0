Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F206218AD68
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgCSHlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSHlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:41:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA4920722;
        Thu, 19 Mar 2020 07:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584603678;
        bh=MO+NXxC2ru+6U8efhGIOeMuaU3KCYOfWUWLNXaZJIuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2LFVyVvejhAw79ntILCZBNfoELTVDaAgW/1w3VT1y1mfP7lO1Zo3AJxRikxQIfcJP
         usImDWdez9ROdym5KXCW3MeUJP9hXcshJxL2VrjiBw0W0Icnr9UEcPVzr5QSz/qopf
         L5knfT7tFTJRXKQ+5G0ZWgCewEjW0xjdJw4HoNCo=
Date:   Thu, 19 Mar 2020 08:41:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.19] i2400m fixes
Message-ID: <20200319074116.GB3442166@kroah.com>
References: <955a1f7af63548fb6a311c04329663961eb2b610.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955a1f7af63548fb6a311c04329663961eb2b610.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 10:14:29PM +0000, Ben Hutchings wrote:
> Please pick the following commits for the 4.19 branch:
> 
> 2507e6ab7a9a wimax: i2400: fix memory leak
> 6f3ef5c25cc7 wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
> 
> I previously sent these to you for other stable branches, but
> accidentally missed 4.19.

Looks like Sasha added them now, thanks for the report.

greg k-h
