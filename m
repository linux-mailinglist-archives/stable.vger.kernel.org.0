Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808F613B156
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 18:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgANRui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 12:50:38 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:57256 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANRui (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 12:50:38 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1irQKp-0002Jn-TO; Tue, 14 Jan 2020 17:50:36 +0000
Message-ID: <41577104e06f774691365564d0a74b46e16b50e5.camel@codethink.co.uk>
Subject: Re: [4.19-stable] Mostly securit y fixes
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Tue, 14 Jan 2020 17:50:35 +0000
In-Reply-To: <1eaa745218d25ab3c5c61361ae0d9b0601f1d99f.camel@codethink.co.uk>
References: <1eaa745218d25ab3c5c61361ae0d9b0601f1d99f.camel@codethink.co.uk>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-01-14 at 14:47 +0000, Ben Hutchings wrote:
> Some more fixes that required backporting for 4.19.  All these fixes
> are related to CVEs though some of them don't seem to have any security
> impact.

The last of these (for dccp) should probably go to you via David
Miller, though.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

