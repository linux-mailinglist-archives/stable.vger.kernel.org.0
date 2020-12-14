Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F8C2D9A87
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbgLNPDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:03:01 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:42063 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgLNPDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 10:03:01 -0500
Received: by mail-lf1-f44.google.com with SMTP id u18so30839654lfd.9;
        Mon, 14 Dec 2020 07:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rNjw8fLVk9WQ4dMTafx3Vq87Bdz/DhQRF/deifNhG7w=;
        b=Fr7N4hY+nwb/Nv0c/sz6vhxDMhPHcmTsfI0zbgWsYoQIJNtJZyRwaaiJdq3gVny4g0
         bvPgjXl7Vj5b0uORNqmZQuX79lkzh5GsXER+oMsMKf9+w5R9mX7JQj9zg/j1LvgVlvnF
         ZNbTWFJqrGUVi1Z/fu5g0mrn7KVONvkPyoam6xcevxmeaU2mt1dUKRp31zNGbj0Tyecy
         guLjDLgZywwUuRHPWY8v/Ac5BjwUjl4q+Hbi3vzMjt2ZyN4Z6CnrrXj3QF1gsqYrc/BU
         gR1HG/CN7PGOEvv3WkV4CANPXm1XiSqxtqLyRFePN08JiKODb1AD0bBnURQ1SPVWX+Fm
         EaNw==
X-Gm-Message-State: AOAM531rKHoWSijjxCOyY+acXZMGvsGZdrZCTgEPZijdQE0EksIlwj6z
        SP5HaL/TBKjP5pgaDc6SaeI=
X-Google-Smtp-Source: ABdhPJxEA9hEa5PT/lNq1mMVL6L77Be5Q6dQaCnnBCnztxc7XgZJ/iEWRtzxWzmsffU5XCyfB9Mriw==
X-Received: by 2002:a19:483:: with SMTP id 125mr9350226lfe.19.1607958139245;
        Mon, 14 Dec 2020 07:02:19 -0800 (PST)
Received: from xi.terra (c-b3cbe455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.203.179])
        by smtp.gmail.com with ESMTPSA id v14sm2166229lfe.270.2020.12.14.07.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 07:02:17 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kopMb-0007vY-As; Mon, 14 Dec 2020 16:02:14 +0100
Date:   Mon, 14 Dec 2020 16:02:13 +0100
From:   Johan Hovold <johan@kernel.org>
To:     syzbot <syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com>
Cc:     andreyknvl@google.com, gregkh@linuxfoundation.org,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in yurex_write/usb_submit_urb
Message-ID: <X9d+dZq/IA+tiw5v@localhost>
References: <X9dDkwlOTFeo9eZ6@localhost>
 <000000000000af6ec005b66dbaa2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000af6ec005b66dbaa2@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 06:48:03AM -0800, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in yurex_write/usb_submit_urb

It appears syzbot never tested the patch from the thread. Probably using
it's mail interface incorrectly, I don't know and I don't have time to
investigate. The patch itself is correct.

Johan
