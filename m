Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEACD10C456
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 08:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfK1Hhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 02:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfK1Hhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 02:37:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DBA42154A;
        Thu, 28 Nov 2019 07:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574926657;
        bh=CRxHmCQ2CYx3SAi4tWeEHuPCghWPDjwC0Yp9FEG3nW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UxTVDXvwpxXr9s5Tc161IySHkiC1rJJPf0iGlaqWZ/oOtp4aJsyJQ75466v1FPWWr
         +aaIuJ9dFp+gIhhdybkYDnIRspD3JcbCyO80UhzPInggORfRO0n50ovI5hJ0tcOuAN
         lDJ6N4RQSAq/ZHCCrCIHdQrfCWwiAaCLNcN4tJiA=
Date:   Thu, 28 Nov 2019 08:19:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bob Funk <bobfunk11@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Willy Tarreau <w@1wt.eu>,
        stable@vger.kernel.org
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <20191128071920.GC3317260@kroah.com>
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123092701.GA2129125@kroah.com>
 <e452278c-4b5c-59fc-441c-94b41d817503@gmail.com>
 <20191123192244.GA16156@1wt.eu>
 <20191125133048.GA12367@sasha-vm>
 <de753b87-d419-0b54-53c5-2efb48c7600f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de753b87-d419-0b54-53c5-2efb48c7600f@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 08:17:25PM -0600, Bob Funk wrote:
> I tested out the patch that was announced today for the 4.4.204-stable
> review and
> all is working well here. Thanks for addressing this.

Wonderful, thanks for reporting this and for testing.

greg k-h
