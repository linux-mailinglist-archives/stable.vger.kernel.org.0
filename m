Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5036A1225BE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 08:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLQHnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 02:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfLQHnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 02:43:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1C42067C;
        Tue, 17 Dec 2019 07:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576568628;
        bh=kptlOiRgJufEw3fZflVDHvpIJt3uWkgmbMjqR8f5lp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SKKEMOy7aSNPfH9hRIPeFgD47PxcqRhW3TEa80mkGazgGZvvjdzootHYcYVAbPNUR
         6TLjbgPlesvfy/OfNIMikopZpC6IKM9Wbrjae0NbQbOS1a8XYjkVKZIznVFlEsYQdS
         6/MlGvF1MELJWq6OvQ0mqbmQtAHcrgU2kfCPqk6E=
Date:   Tue, 17 Dec 2019 08:43:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191217074346.GB2474104@kroah.com>
References: <20191216.141009.1431387601178097325.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216.141009.1431387601178097325.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:10:09PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.3 and
> v5.4 -stable, respectively.

Many thanks for these, I'll queue them up after this next round of
stable kernels are out.

No need to do anything for 5.3 after this, it will be end-of-life.

thanks,

greg k-h
