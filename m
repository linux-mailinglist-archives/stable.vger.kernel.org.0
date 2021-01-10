Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6152F04C0
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 02:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbhAJBxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 20:53:11 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:47153 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAJBxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 20:53:11 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6A08022708;
        Sun, 10 Jan 2021 02:52:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1610243549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=16pmvivc9vFTk99NqF9j4WTSYp42RpBOCt/XNxbgRtA=;
        b=iGOorF0Pg1R2Lz421FCYlE0ICtda/WSEpJbhFiRWk0j/zpv9mdVf/hBJsVKdsoImZoUTam
        wu0WwKO7a6lGbFq0Fur8yUkTYhGYfGTokaxmMobWVUpMOG6DmRlZyFIce1nLSa9c+39i13
        /F2t+2KRtNHJQ99Q3HoMl6CjTm/kies=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 10 Jan 2021 02:52:29 +0100
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] driver core: Fix device link device name collision
In-Reply-To: <20210109224506.1254201-1-saravanak@google.com>
References: <20210109224506.1254201-1-saravanak@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5d8ea5751e761df7511a3f2db4de1273@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2021-01-09 23:45, schrieb Saravana Kannan:
> The device link device's name was of the form:
> <supplier-dev-name>--<consumer-dev-name>
> 
> This can cause name collision as reported here [1] as device names are
> not globally unique. Since device names have to be unique within the
> bus/class, add the bus/class name as a prefix to the device names used 
> to
> construct the device link device name.
> 
> So the devuce link device's name will be of the form:
> <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> 
> [1] - 
> https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> 
> Cc: stable@vger.kernel.org
> Fixes: 287905e68dd2 ("driver core: Expose device link details in 
> sysfs")
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Tested-by: Michael Walle <michael@walle.cc>

Thanks!

-michael
