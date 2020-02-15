Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FE715FD0A
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 07:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgBOGOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 01:14:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgBOGOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 01:14:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 06BA1AC8F;
        Sat, 15 Feb 2020 06:14:03 +0000 (UTC)
Date:   Sat, 15 Feb 2020 07:14:02 +0100
From:   Jean Delvare <jdelvare@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 495/542] docs: i2c: writing-clients:
 properly name the stop condition
Message-ID: <20200215071402.027c9120@endymion>
In-Reply-To: <20200214154854.6746-495-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
        <20200214154854.6746-495-sashal@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Feb 2020 10:48:07 -0500, Sasha Levin wrote:
> From: Luca Ceresoli <luca@lucaceresoli.net>
> 
> [ Upstream commit 4fcb445ec688a62da9c864ab05a4bd39b0307cdc ]
> 
> In I2C there is no such thing as a "stop bit". Use the proper naming: "stop
> condition".
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  Documentation/i2c/writing-clients.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/i2c/writing-clients.rst b/Documentation/i2c/writing-clients.rst
> index ced309b5e0cc8..3869efdf84cae 100644
> --- a/Documentation/i2c/writing-clients.rst
> +++ b/Documentation/i2c/writing-clients.rst
> @@ -357,9 +357,9 @@ read/written.
>  
>  This sends a series of messages. Each message can be a read or write,
>  and they can be mixed in any way. The transactions are combined: no
> -stop bit is sent between transaction. The i2c_msg structure contains
> -for each message the client address, the number of bytes of the message
> -and the message data itself.
> +stop condition is issued between transaction. The i2c_msg structure
> +contains for each message the client address, the number of bytes of the
> +message and the message data itself.
>  
>  You can read the file ``i2c-protocol`` for more information about the
>  actual I2C protocol.

I wouldn't bother backporting this documentation patch to stable and
longterm trees. That's a minor vocabulary thing really, it does not
qualify.

-- 
Jean Delvare
SUSE L3 Support
