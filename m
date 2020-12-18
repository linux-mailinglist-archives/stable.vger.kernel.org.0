Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB242DDC3E
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 01:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgLRADn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 19:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgLRADm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 19:03:42 -0500
Date:   Thu, 17 Dec 2020 19:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608249782;
        bh=SazuEfbj1jNY32HYgKoZkvRpVPyocKkt0kD0zzBZC2M=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=A2t12e36lzt5GpvOWR6pRLL1gLDJOe1+UMHVv7Z/d16AKeCQ0RkbA86qGwzAQ++nt
         tclxCntMuxqCsHrcO9JxRQZ4gnzyXbO2isS+e+sI2I8UZk45AvBsSysrNJxwG1jYQx
         pRVSaRVXkC5i2Ynof4mhdTJyzIhX/Gjjh+qECQOJiqoESXiac6lWGq/9KZwwW39fCk
         pE+U8r/3xtS/6k99zlZGqvt1xwOrP9z1E/aKRJjnJO2ScEyBwF34C7x9SVHXq0YzxO
         rAS3iNT36P304HAAlBJL1dcoDdUI7lePty93HG/I0RXwxVhiCGpiK6CFGEFGGQCCHn
         jkLqvS6sXKGOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     Young Hsieh <youngh@uber.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: Question for AMD patches
Message-ID: <20201218000300.GC643756@sasha-vm>
References: <1B44E762-F9F2-4E2B-BFEF-6F032BE8841E@uber.com>
 <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
 <20201217203211.GB643756@sasha-vm>
 <D69B8685-4410-4839-AB67-A89D77F82203@uber.com>
 <DB3DB0E4-4751-4527-B030-40EF0B11F195@uber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DB3DB0E4-4751-4527-B030-40EF0B11F195@uber.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 18, 2020 at 07:34:07AM +0800, Young Hsieh wrote:
>Hi Sasha,
>
>The other reason we are wondering if 5.4 has backporting is we are not very comfortable about using the bleeding edge. Do you think 5.10 is stable currently?  Thanks for your help again. :)

Hi Young,

See https://www.kernel.org/releases.html for a list of the LTS branches.

The 5.10 kernel is already designated as LTS and should be used by most
stable tree users; this is the preferrable kernel to adopt right now.

The AMD hardware enablement stuff won't be backported on top of 5.4.

-- 
Thanks,
Sasha
