Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164B845A68E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhKWPgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 10:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhKWPgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 10:36:05 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A791C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 07:32:57 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id x9so22064315ilu.6
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 07:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AwyKwxR7UtlG8i9XGiWN1sAiezKnnV5OVVyTvBUxiqE=;
        b=JSp0oNfqzBSMTE6elXgHsRpTeeb4EevbdcFjEtsMka/qG5i3EYl+gYMMoL5Ul7bK3r
         ePv9xfqpyRyal3jBLQTenQzRmPuTl9LSaiHKrJwlFOxI5Er7DkUbhnSxcr8Hx+WfPncG
         hHKTfN7sdsmlDwye4EDE5it5oUW+blJ2Yr12Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AwyKwxR7UtlG8i9XGiWN1sAiezKnnV5OVVyTvBUxiqE=;
        b=gOfytJyMgJuPRVIRibFUjMomRXMw5QCPiGUtqTt1Lb3tYBxyBGGLBDN/lhKpB3fpD4
         4XXpyApetNyYrKuqp9PPIz8WmxnVkuJb8A4gjRs0Y7l7LPHWWdcDihSot11OymoyU527
         WQoCcSsQ0UIpas7PYmhIDIsInyplIEy8i7ik0UGHIOWKf+dThLsA/MIFpovEj/ak48gQ
         oX1TXAqAP4N/qJ63VVWPho77jC5A+B+hqJ3R3yo9kk8lDD1dZRDJD85Kxjux8iyMD5ew
         SbSRhegsp0W0Oux/I5Tr+fzyhA4p6o11fg3IzNTsZXSrs1Ya6SVUT9iYPMdKTotvcL87
         sW0A==
X-Gm-Message-State: AOAM5337X/Cz0PaXxAw8Cle4Glb7+s2gJgYaoZPDSRQooh6XYYV/gYn9
        n/xSXdK/Psc4fx6GmJK9kBZGUHoVXUx03g==
X-Google-Smtp-Source: ABdhPJxePsTM8nsRqgdhjpC9gf+GWAliYARw6qis3Ib6CN4W9ZY0a3CXORs+LsWOAsRPRoJxozVceA==
X-Received: by 2002:a92:d149:: with SMTP id t9mr2580804ilg.185.1637681576955;
        Tue, 23 Nov 2021 07:32:56 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id 1sm7239199ill.57.2021.11.23.07.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 07:32:56 -0800 (PST)
Date:   Tue, 23 Nov 2021 10:32:54 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     "Fernandes, Francois" <Francois.Fernandes@conduent.com>
Cc:     "webmaster@kernel.org" <webmaster@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [External] - Re: EOL Kernels versions
Message-ID: <20211123153254.pqz4ii7jhf3c5ltz@meerkat.local>
References: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
 <BN8PR20MB26741ED4B21328F5F64CFC14F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BN8PR20MB26741ED4B21328F5F64CFC14F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 03:13:46PM +0000, Fernandes, Francois wrote:
> Hi Konstantin,
> 
> Thanks a lot for your quick answer.
> 
> I found some complementary information here :
> https://itsfoss.com/why-distros-use-old-kernel/
> 
> It seems that even if the kernel version is EOL it's not a matter while the
> distribution version (in our case Debian 10 (Buster) is still under support.
> Is my understanding correct ?

Yes, distributions may choose to maintain their own LTS versions. If you are
basing your work on a distribution like Debian and aren't shipping your own
kernel, then you should plan your work around the distribution's announced EOL
dates.

-K
