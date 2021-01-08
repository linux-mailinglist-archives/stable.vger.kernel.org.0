Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9182EEABF
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbhAHBLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:11:35 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42393 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729697AbhAHBLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:11:35 -0500
Received: from [IPv6:2a02:810c:c200:2e91:5d83:d08d:7619:b39] (unknown [IPv6:2a02:810c:c200:2e91:5d83:d08d:7619:b39])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6549B22EE3;
        Fri,  8 Jan 2021 02:10:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1610068253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWcGuPKnCsjgdjTU240313EwjY6cL6uRbT0X5lNz1T0=;
        b=LqkRix/wqrcI8bBONXIW8lDx1i96eYzlr2EW10HgKz9qnWVGnPZLAJd1ZiOTvYvbwssyYB
        cSu9NDlgsJaq6a1WPAB/5PDbKD4DfgBb051iN8NDvuRFbQWjhQDsZsekq8nZ00oFMhyr/l
        Cswv+P+xPuyRbHvZPz7xt+dhfmQKoNk=
Date:   Fri, 08 Jan 2021 02:10:51 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGETcx_CJjOxim+CEptLRSgfYAKHBbP8rHW7BY+U7-X+L2eObg@mail.gmail.com>
References: <20210107234136.740371-1-saravanak@google.com> <b3cda25a3e3911a12a8766f141c9e300@walle.cc> <CAGETcx-q04E0TW6LMoyoRC64xH25Uogk7twSNEbT411ciZPfUw@mail.gmail.com> <CAGETcx_CJjOxim+CEptLRSgfYAKHBbP8rHW7BY+U7-X+L2eObg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] driver core: Fix device link device name collision
To:     Saravana Kannan <saravanak@google.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
From:   Michael Walle <michael@walle.cc>
Message-ID: <A645B0D5-82C4-46CE-80AD-1EF40D26ACCA@walle.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 8=2E Januar 2021 02:00:32 MEZ schrieb Saravana Kannan <saravanak@google=
=2Ecom>:
>On Thu, Jan 7, 2021 at 4:43 PM Saravana Kannan <saravanak@google=2Ecom>
>wrote:
>Nevermind, I see it now=2E Also, in the future, if you can dump the logs
>in some kind of pastebin site, that'd be nice=2E Avoid the emails
>becoming unwieldy and also avoids the log lines from wrapping=2E

I thought about a pastebin=2E But then decided against it because they mig=
ht be deleted in the future=2E So if anyone looking at the mail archives he=
 might only get dead links=2E So=2E=2E=20

dunno how this is handled on the LKML, tbh=2E=20

-michael=20

