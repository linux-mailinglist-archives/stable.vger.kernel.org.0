Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE54148D08
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390134AbgAXRhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 12:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390106AbgAXRhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 12:37:19 -0500
Received: from localhost (unknown [84.241.198.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4006020709;
        Fri, 24 Jan 2020 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579887438;
        bh=8y6qiUBr3k966rZqNeQ+ebfw9E7qa43OnEMTfLCg/Og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+2MGmqraSSKfOGp8vP7Ojbc3C2OViJMMytEVcEQuD9TLTZk7voqGs15jfWZlWdXC
         rfCSrQcqG21WhVHEhkEaxxP5WWMCcjwaXrlHhmj4Kw19q7RRIymh4SC8qHbC1sshJA
         Z8lWTCm9GxnPUe7IJvCxAvS6W3/8PEJJaDfP9uuk=
Date:   Fri, 24 Jan 2020 18:33:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 402/639] media: Staging: media: Release the correct
 resource in an error handling path
Message-ID: <20200124173322.GA3166016@kroah.com>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093137.297261658@linuxfoundation.org>
 <1578497930.3188.1579867610896.JavaMail.www@wwinf1n19>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1578497930.3188.1579867610896.JavaMail.www@wwinf1n19>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 01:06:50PM +0100, Marion et Christophe JAILLET wrote:
> Hi,
> 
>  
> 
> Apparently is patch is no more needed in 4.19.98+.
> 
> 'res' is not used anymore in the error handling path (or its use depends on another patch which has not been backported). 'res' can safely be overriden.
> 
> There is no need to add extra variable 

Ok, now dropped, thanks.

greg k-h
