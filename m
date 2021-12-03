Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA64675BF
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380199AbhLCK7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237898AbhLCK7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:59:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80DEC06173E;
        Fri,  3 Dec 2021 02:56:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 672A762A02;
        Fri,  3 Dec 2021 10:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0FBC53FAD;
        Fri,  3 Dec 2021 10:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638528965;
        bh=xcd6qCvNc9eCZVPRbxRPtVsEptcOqtGydxpUyb81wgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CORB7spGLCd0A6HhQbRWzCNj6QPsI7hpilW9UKyRafB2hN0mVQGTRM3R34RsyLdFO
         AJAFZfA16dAna85G8U+Mc+mj6aCTylm9hQ9mc8UKbJR1OsERWF2jiw5CLmIT4y+e1L
         dA3v3AFkOYFYxsUYZscoRUseJauAQuV2X0r7IGrX8h1y/jWk4REj0mXoM/2ujRXZph
         81Bd/deu40KudTR+SmhV+B08WwRksQokqxMW9bdorTyl+fDdMl5JIXAC2xe+src+GZ
         rgNbB7wqAzzn+Nzw+tScnMgEzN4TxxA+AsJgojk52/f14Vys1q1r41calGg/P25CKO
         fI1MZMQPyURBA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mt6EF-0002Dg-O8; Fri, 03 Dec 2021 11:55:47 +0100
Date:   Fri, 3 Dec 2021 11:55:47 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <Yan3s35hsyK0DEGH@hovoldconsulting.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
 <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
 <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
 <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
 <Yanxc/229JFkuP/v@hovoldconsulting.com>
 <Yan241Kg7O+qgQXG@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yan241Kg7O+qgQXG@pendragon.ideasonboard.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 03, 2021 at 12:52:19PM +0200, Laurent Pinchart wrote:

> > I noticed that this one hasn't showed up in linux-next yet. Do you still
> > have it in your queue or do you want me to resend?
> 
> It should be in Mauro's queue now:
> 
> https://lore.kernel.org/all/YacOun3Diggsi05V@pendragon.ideasonboard.com/

Perfect, thanks!

Johan
