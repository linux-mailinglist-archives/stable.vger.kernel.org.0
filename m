Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1134C123FAA
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 07:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfLRGfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 01:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfLRGfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 01:35:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B746120717;
        Wed, 18 Dec 2019 06:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576650902;
        bh=XmUycAZRkwjpaQOLv9Rk75iZpsj0hWjMGC4GnKM1WeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2UW63mmqUibFIaxnhSAZPdWqORBPJSfWprgOH9ZFgJJvKx176iEqUbtUTnRaFULwh
         sM7n5QKTPHOuNRCL29nryOVIjG7TDP3XlhmevGEE59qISZXbxUNjoQxK0luJMz74Z0
         ih5YkW4qyU42nuM7xVs2yySi3PGM2pesUTQxG9IU=
Date:   Wed, 18 Dec 2019 07:34:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please apply commit e9a9853c23c13a3 ("nvme: host: core: fix
 precedence of ternary operator") to v4.9.y and v4.14.y
Message-ID: <20191218063458.GA1235324@kroah.com>
References: <4cbbe4b0-43c0-a365-e94d-0b34ac5a6dea@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cbbe4b0-43c0-a365-e94d-0b34ac5a6dea@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 04:42:51PM -0800, Guenter Roeck wrote:
> Hi,
> 
> Commit e9a9853c23c13a3 ("nvme: host: core: fix precedence of ternary operator")
> fixes a real bug and should be applied to v4.9.y and v4.14.y.

Now queued up, thanks.

greg k-h
