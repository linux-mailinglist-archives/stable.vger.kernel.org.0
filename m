Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855C6360B28
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhDON6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDON6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 09:58:07 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF02C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 06:57:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id x12so16237561ejc.1
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 06:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E0B6LJ9MQlxo3iqh798Y3fz6SwUA0hzfEWerzCi9sQc=;
        b=DUylb96v09JJTOWaj8YJHjxZ4PLlF1AMpKWlB4UrMpLJxgmgzwbQvl2QuMYXSoCSzI
         CchgEhbAGA3Jo50Rv+WQh9B16SUsRNU5TFxmvPiwb5O4FNZ+mgL1ejBEcMckbWShqd0K
         7sJLbFRXwwQN5nTd27bQVuBlbAYWGpbb+ynwMothsEXC8IhpEH75fXtLSTcWj5aGAVxK
         IwB2hcATmYQNCwxsOdu27YzNlBh3Fi7MIT8fnK+xWDVfra3JSEp8ER4EyU463bcydbRD
         pTKepMUM3gUWLx5ndRpEhzj/FTxf+J0xQc8lBI3VsmnDr9YBWO+6QprXoVATPjadjqGo
         ZOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=E0B6LJ9MQlxo3iqh798Y3fz6SwUA0hzfEWerzCi9sQc=;
        b=o35mb9kfGsuYHxkku+9RGdMdqdX029t/wi9KJfifcSZ4zLqPlkruqNzkYhOBqR/ab4
         BuHUIdVFItvU6CJa2rSi8QdMrafFyKapY/c0dzWfCaKwmNgooqYFWBwr/B2Wrc/Sp+Ab
         lUKghS2o5n/YIe6vZIiVU2f1qWd+dyD85Hk8wVMDids0StYP5tB+qzQ4jrS6jgQTazBf
         WZeL6xsilHVzvC7BsQwfOmF+EG4PwyWrXm02kI6nCDZMYhejeEgPodXnOO6VfcKmmv2N
         YlYVZtl05rmTk5Po5QZldq7GHqn5SFWAifJ13Ex9DL6bq7MDohNsXhpFnXYfeJmUexlO
         cwpw==
X-Gm-Message-State: AOAM530qTKpAHsDL1o9YcoywF7JE4a1ttyH77dUPj6QBfV0tFQ0m7puo
        RS3w4oTRhQK3eB8+N90qh+Q=
X-Google-Smtp-Source: ABdhPJyeo1QN487ijdeN+PrDWuuB1Tih5EyXXZ50dAHOQQI7awqk2jAo+s8Y8GuEHkCtzTuEfWmezQ==
X-Received: by 2002:a17:906:5490:: with SMTP id r16mr3710449ejo.352.1618495062229;
        Thu, 15 Apr 2021 06:57:42 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id u13sm2106085ejn.59.2021.04.15.06.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 06:57:41 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Thu, 15 Apr 2021 15:57:40 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        NeilBrown <neil@brown.name>,
        George Hilliard <thirtythreeforty@gmail.com>,
        Christian =?iso-8859-1?Q?L=FCtke-Stetzkamp?= <christian@lkamp.de>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Sergej Perschin <ser.perschin@gmail.com>,
        John Crispin <blogic@openwrt.org>
Subject: Re: "Backport" of 441bf7332d55 ("staging: m57621-mmc: delete driver
 from the tree.") as well for older stable series still supported?
Message-ID: <YHhGVJTBHx55SYYi@eldamar.lan>
References: <YHdGBm2WHb5I8FFW@eldamar.lan>
 <YHgIEbn1UqhXHdzr@kroah.com>
 <YHghlaftXxH49lUy@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHghlaftXxH49lUy@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Apr 15, 2021 at 07:20:53AM -0400, Sasha Levin wrote:
> On Thu, Apr 15, 2021 at 11:32:01AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 14, 2021 at 09:44:06PM +0200, Salvatore Bonaccorso wrote:
> > > Hi Greg, Sasha, all,
> > > 
> > > Prompted by https://bugs.debian.org/986949 it looks that files with
> > > prolematic license are present in stable series in
> > > drivers/staging/mt7621-mmc/ prior to 441bf7332d55 ("staging:
> > > m57621-mmc: delete driver from the tree.") where those were removed in
> > > 5.2-rc1.
> > > 
> > > As the license text at it is presented is problematic at best, would
> > > this removal make sense as well in the current other stable series
> > > which contain it? The files goes back to it's addition in 4.17-rc1.
> > > 
> > > So it would remain v4.19.y where the files should/can be removed as
> > > well from the staging area?
> > 
> > Yeah, it is odd, and we probably should not continue to distribute new
> > updates with it in the tree.
> > 
> > As the commit does not backport cleanly, can you provide a working
> > backport that I can apply?
> 
> I killed it :) Thanks for the heads up!

Thank you Sasha and Greg!

Salvatore
