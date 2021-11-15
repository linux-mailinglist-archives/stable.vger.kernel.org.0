Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656A845047D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhKOMio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhKOMil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:38:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF71E619E5;
        Mon, 15 Nov 2021 12:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636979744;
        bh=UKaw5MLZFXtSoFr7dwEBl6Bp/BM4fZPiLr05yVJNgoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOsPnON5hDNQgp0nBoq+GddqCY3bv+DacSMT6I9IFG9B1RuuGq6ocW7yfWLX6sL/C
         OUFgWk+LbfxlFYUmz4m5IzfeKPMUVrwnUJOUjTUIltjUOiCjm4v7r8LYq4NIQ3ReQm
         oGb9bOgj77uH23B0qVxpqfozMxf2fW0oKJehBs7Y=
Date:   Mon, 15 Nov 2021 13:35:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
        Julian Sikorski <belegdol@gmail.com>,
        Jeremy Allison <jra@samba.org>
Subject: Re: smb3: do not error on fsync when readonly
Message-ID: <YZJUHcRiFyJwgdRw@kroah.com>
References: <CAH2r5msbc9A0V2qh2Prx4WSNsDAWp4m5Sj76YgKN8Qb7fWbZdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msbc9A0V2qh2Prx4WSNsDAWp4m5Sj76YgKN8Qb7fWbZdw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 12:01:29AM -0600, Steve French wrote:
> Please include "smb3: do not error on fsync when readonly"
> 
> Commit id:
> 71e6864eacbef0b2645ca043cdfbac272cb6cea3
> 
> It fixes an fsync problem over SMB3 mounts, reported by Julian, when
> the file is not opened for write.

Queued up for 5.15.y and 5.14.y, thanks.

greg k-h
