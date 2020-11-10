Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83D72AD2BE
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgKJJsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:48:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJJsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 04:48:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D3E20780;
        Tue, 10 Nov 2020 09:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605001685;
        bh=5/U0jbhIfisk5oUWjv43AJMhqiF7LsASgFchI0Q6S58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kGWohQ4pjXge24xpwF4Kc1Wy2Z1N8x67U7+u4Gk4N083EKSpOP2m2mZJ2wtohSwQ7
         wQiFPzrkVz4PN0SYCTfYa6x6ZgCnc1J+NPgqWNvlrfUoQuclFsZrWSQh6pT82a7Qas
         weZF0FCE34nm+eXOFDCxah8jySmggCkBj1F8ZfK0=
Date:   Tue, 10 Nov 2020 10:49:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yaoaili =?utf-8?B?W+S5iOeIseWIqV0=?= <yaoaili@kingsoft.com>
Cc:     "yaoaili126@163.com" <yaoaili126@163.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Fix error return value in
 apei_map_generic_address()
Message-ID: <X6piD9SqUKCZzHTY@kroah.com>
References: <20201110082942.456745-1-yaoaili126@163.com>
 <X6pbGq24Gta7Go0t@kroah.com>
 <3fcd32bf58204b26915474fab652e6bb@kingsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3fcd32bf58204b26915474fab652e6bb@kingsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 09:42:21AM +0000, yaoaili [么爱利] wrote:
> Sorry for confusing. I am really new to kernel community!
> I should just add the tag 'Cc: <stable@vger.kernel.org>' , not really cc to stable@vger.kernel.org
> sorry for this!

No, that's fine, you just didn't send this to us with any sort of
context at all.  The patch needs to be accepted by the subsystem
maintainer first, right?  Please read over
Documentation/process/development-process.rst for all of the details on
how to do this correctly.

Good luck!

greg k-h
