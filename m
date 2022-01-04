Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B924B483F77
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiADJ4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiADJ4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 04:56:31 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2846C061761;
        Tue,  4 Jan 2022 01:56:30 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t26so74985673wrb.4;
        Tue, 04 Jan 2022 01:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iIGRBOba+jyxeaJMzStvp1uRrNmWJMNLyQXsGX8NDd0=;
        b=okNuojHQw/d+wTIiH9UCOrOHo1aGKcbQMlRIDI8L1vZ80d0DPSjJ3M/kayI0c5KKqw
         GSOjYPPgZVzHNj1PbD8ZsHl6F+Y/vfIA3o7881RcuFr+s/Yg7LYwYds52BQ7fk/zy37C
         vzYPyWVncnxg6rXDILSj3kfWrKBybWlKckPurwEWD4Qr1U3+WGxV5CQdva4bgb8YFrLL
         LHGOqikAL6dXiOK4y1JkBf3R5x+jatVXaqgtfrLOpacEhJcIaohw6+zvn/lXOVVrOxjU
         YR392MzZQkUD0Itp+hE4eD+WOFm2MU2ldYeb/Zj6c+6cUn8GE/G66JB9YPhWQT892uK4
         F97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iIGRBOba+jyxeaJMzStvp1uRrNmWJMNLyQXsGX8NDd0=;
        b=lqpGK4fqQ7l8FglRMnsIQTcYLrQ1aX3OAX5TK8P0iAijlvGHQAUgHWhHPdDgvfZxy+
         WbOFCiu1axlg+SfvuBkcZvrvYs2wquYmlZKWG489tBEdrcV6Ml/TjzvEdbaqJnARwnRP
         I1n9iTyrr9Ti1ckZqn1lcSbHqBXo+9BJBTiZdG60MydTbn7Gl9lgo3UXYiTtGVaeYUEA
         +A3EHqzGU+jBL1pEe7A1b9UgNMG5wwROiD3txEYhbdBREN+zva42hTB7hQwi9ud7MNcb
         epUY1QFz5h4mUvgjsvaHw1uarbSnDMLdTw1tpExWkSlffwySaivScopYyn9tfRhVom2P
         14vg==
X-Gm-Message-State: AOAM531xfEuNSEfrvRPPIDPx4y5j/a5R1eBnlIuQsdCtmherFfQjS3gn
        VLK1rSDIk18KzBzkEyqXl20=
X-Google-Smtp-Source: ABdhPJxCrUiAK9sHdqC4aHhft4kT79B0K3ECAoEywLNImsoUemZ/5TlSFz6MrCFeWkhkdvED34MHmA==
X-Received: by 2002:adf:80ca:: with SMTP id 68mr40569481wrl.528.1641290189483;
        Tue, 04 Jan 2022 01:56:29 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id l7sm37515891wms.1.2022.01.04.01.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 01:56:29 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 4 Jan 2022 10:56:28 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Chao Yu <chao@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenqing Liu <wenqingliu0120@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.10 60/76] f2fs: fix to do sanity check on last xattr
 entry in __f2fs_setxattr()
Message-ID: <YdQZzAQg4vIQNXc4@eldamar.lan>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.779679392@linuxfoundation.org>
 <YdNmdhsKS5ZWHOlB@eldamar.lan>
 <12184f7c-3662-7fdc-d44f-23ef29102ddd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12184f7c-3662-7fdc-d44f-23ef29102ddd@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Jan 04, 2022 at 05:29:30PM +0800, Chao Yu wrote:
> On 2022/1/4 5:11, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Mon, Dec 27, 2021 at 04:31:15PM +0100, Greg Kroah-Hartman wrote:
> > > From: Chao Yu <chao@kernel.org>
> > > 
> > > commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.
> 
> I've no idea.
> 
> I didn't add this line from v1 to v3:
> 
> https://lore.kernel.org/lkml/20211211154059.7173-1-chao@kernel.org/T/
> https://lore.kernel.org/all/20211212071923.2398-1-chao@kernel.org/T/
> https://lore.kernel.org/all/20211212091630.6325-1-chao@kernel.org/T/
> 
> Am I missing anything?

The line is added when a commit from "upstream" is added to the stable
series to identify the upstream commit it is taken from for
cherry-pick (or backport).

Strange so, that the fix is not in mainline actually yet.

Regards,
Salvatore
