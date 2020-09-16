Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C154926BD20
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIPGao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgIPGam (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:30:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 200E9206A5;
        Wed, 16 Sep 2020 06:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237841;
        bh=bHiFyfQLM4tFdHBjGlBpsOnZBsv1ui/XmTjfywasNNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EI/nHUov+Pk801YWEgbxymnrmrLJCkjZ5glzHxv/ggtcJMGRLARWsf6jSHBbwZzXV
         0XrLQmHx+z4TLhGGqeQLrtkhgHQ81opXL9lVRa2+Cus3wf124ylCqnLJ3H0hZdCduN
         cpe4Z6qdnllBvRVTMhhCyAOPWtRwKJ8WbxWKSOgE=
Date:   Wed, 16 Sep 2020 08:31:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/5] Add support needed for Renesas USB 3.0
 controller
Message-ID: <20200916063116.GI142621@kroah.com>
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 02:30:34PM -0700, John L. Villalovos wrote:
> Add support needed for the Renesas USB 3.0 controller
> (PD720201/PD720202).  Without these patches a system with this USB
> controller will crash during boot.

Is this a regression, or something that has always happened?  If a
regression, any pointers to what commit caused this?

this really feels like a "new feature" addition to me, unless this used
to work properly.

thanks,

greg k-h
