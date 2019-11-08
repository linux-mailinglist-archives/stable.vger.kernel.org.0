Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692FBF4CED
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfKHNPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfKHNPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 08:15:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393412087E;
        Fri,  8 Nov 2019 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573218950;
        bh=UEQXjx3rHyVTBXtZ0Tc5vfcjCQIaZgPguSJQ/mrpUeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P3lgYUkrGd4yBvuVxZZCkDpIt6ldDpAZQOc4rC3k4KRsGb2fa70KpktytlyHu0ato
         za2AfqvOf6+tKDtygXrkRqT4po1I54oZJxTaXwEekI52Y5aH3wSP5fJrg8imHI10X0
         lFhDP5fCJr+SopAxpi6sIyzuX9xk1XKjEsL1yg00=
Date:   Fri, 8 Nov 2019 14:15:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, linus.walleij@linaro.org,
        rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH for-stable-4.4 00/50] ARM: spectre v1/v2 mitigations
Message-ID: <20191108131548.GB761587@kroah.com>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 01:35:04PM +0100, Ard Biesheuvel wrote:
> This is a backport to v4.4 of the Spectre v1 and v2 mitigations for 32-bit
> ARM that have already been backported to v4.9.

Very nice, I never expected to see this happen :)

All now queued up, let's see what breaks!

greg k-h
