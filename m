Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478EF911F8
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 18:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfHQQgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 12:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfHQQgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Aug 2019 12:36:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F5BD2184B;
        Sat, 17 Aug 2019 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566059802;
        bh=CqvbumOIG4ViYSaBGxPMmIJR8VHR4e6F12an6fjp+tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PwYF7W8vCVKrtjsfF1TAYM7N8vfDUxpVMSNSUUE2K7Y5dgO0JbsnDzwJxBiZCDEr2
         Rri5pX32RUZhlDfnXHts1FkUZXbe2a2ADYSQwQJoZqd0kpQGB+a6Q9tQoD9k59Tfrg
         kluaQZTexzfjIK6cDyeiQhrqjszsa9MZUezGzPwo=
Date:   Sat, 17 Aug 2019 18:36:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9 02/13] bpf: restrict access to core bpf sysctls
Message-ID: <20190817163640.GA7684@kroah.com>
References: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
 <20190816225956.GF9843@xylophone.i.decadent.org.uk>
 <20190816230354.GR9843@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816230354.GR9843@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 12:03:55AM +0100, Ben Hutchings wrote:
> Sorry, I've mis-threaded these.  These patch for 4.9 should be applied
> after "[PATCH 4.9 01/13] bpf: get rid of pure_initcall dependency to
> enable jits".

No worries, I'll sort by subject here, thanks for the patches!

greg k-h
