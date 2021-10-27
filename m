Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D624043C314
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 08:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhJ0Gjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 02:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhJ0Gjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 02:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFED60E78;
        Wed, 27 Oct 2021 06:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635316632;
        bh=kuEr7jKL4rFOnl3Ynjj9UaIAg4wBlAAzNNJxNlHsTr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vk1mxDLWmsYBNKeTOipcn4eI79hmLoOTBm6itC76wa4Uyt+Hy+mFvxLOKwalOcTzQ
         sD305EiAY2W8lsJMqlIJ2/eVDhkIEHgo3QaYPNh6EtHQ797xc1Ap9I/ag7TDLMbN8x
         zlvKvM4k6INEvvLAfKm9aFCbTXCbx+Xp32kzub6qHGEIQd8g2J/+G7E2RSl4OVUHys
         dKAmqUg1h5RLuXJVWfjEnyOKT6PRXZys3dMy0m9G/98ZMUW0uVCyPSrbqf38xoTdum
         m3802t9LHCai8vwoqvbJB14LHUMol8rWZU6vncQq8cuc50+XJooKnv9lOyFCNozmEC
         NVZ52f3Em3FXw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfcYR-0002gq-Rh; Wed, 27 Oct 2021 08:36:55 +0200
Date:   Wed, 27 Oct 2021 08:36:55 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <YXjzh8duy+nY8RA2@hovoldconsulting.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
 <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
 <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
 <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 12:50:46AM +0300, Laurent Pinchart wrote:
> Hi Johan,
> 
> On Tue, Oct 26, 2021 at 02:06:55PM +0200, Johan Hovold wrote:

> > Do you want me to resend or can you change
> > 
> > 	s/probe()/uvc_video_start_transfer()/
> > 
> > in the commit message when applying if you think this is acceptable as
> > is?
> 
> I can fix this when applying.

Perfect, thanks.

> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Johan
