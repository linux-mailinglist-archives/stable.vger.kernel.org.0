Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2372D17F6
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 18:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLGR4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 12:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLGR4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 12:56:32 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97E1C061793
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 09:55:52 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id o5so9533933pgm.10
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 09:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/VmFisjt6UGqmwTTXf3GTFuYTAxBMx/lKhpgg3iEckQ=;
        b=SDkl+azn3j6wJQYmaW7uX1FAKZTrbAYcs3bEEK8W58m64eBXQGFSodepF4Vno7/s0U
         qx43TSps/AVAygyg8CNyjB7Ysl0oub7lKLWdtFkc1ulfF/tDRVQlK0N6d0vyGtrgb9PT
         VNaIvq2JFLKwPySsIzWaBuLtSJe/RB0m07BA0MeDOz5z6PT5a7xRvbWyn5LCz/ECZTgT
         G4cW58zCHLwzpm9/Rt57K0LMnNdQnM4QKykvwSGS1CY7P/v1HYQ2e1FaHFezpmGgjWVT
         8e5epbqobEbJUEBu8v8RXOeV9xQqhCyepIXwtCxE6I0DlAxgRlLlh79Q6b62J/0rrUsC
         catw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/VmFisjt6UGqmwTTXf3GTFuYTAxBMx/lKhpgg3iEckQ=;
        b=Ak+X4k/R4RezjzVUYnBYUtc/JfKHihWjeGTFduoRMN3rY5KRIiHn/8UuvT416fdBjT
         UQrbaKhoLQwSdB8vzZTwhDXiNDFqpcRgpQnfIAiWG9GXa5neFZlQSKd4SSmRA0F6khWB
         9YF0bvcGV/nQfQUxIHsPy+MeUDM8h7d77CWrViwRTiqywNovX+Ung5WQ2V1C/x1AS4cI
         D6faEA5Nq7/C5ytQGkgCPgLCT3avniJ90Evg5hl7ZBW0VzOuSw8HF+3tsRR0E0lhel00
         UFOvwrsQdbzvufADaCRnm/Y39gOHC1++dvkB77plBdB8HxUIk9Kem3u4Tnuhjt4dMmtv
         10bg==
X-Gm-Message-State: AOAM531UCYUpD21aLu7F59zX0WkG9YncNqXqqbgbPLLDCtWts+xFr/g4
        HZG9Z9mrCZsWgYW5mNh1QZTn0g==
X-Google-Smtp-Source: ABdhPJyhgMV4r8ALFI9/0TZ08Brv9RVOGMivqz8bi3q2HtDnWZIG+uHWQ2gge2KRqipIV8qSkJ00YQ==
X-Received: by 2002:a63:4516:: with SMTP id s22mr19631724pga.45.1607363751999;
        Mon, 07 Dec 2020 09:55:51 -0800 (PST)
Received: from google.com (h208-100-161-3.bendor.broadband.dynamic.tds.net. [208.100.161.3])
        by smtp.gmail.com with ESMTPSA id d20sm388733pjz.3.2020.12.07.09.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 09:55:51 -0800 (PST)
Date:   Mon, 7 Dec 2020 09:55:48 -0800
From:   Will McVicker <willmcvicker@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        security@kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Will Coster <willcoster@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] HID: make arrays usage and value to be the same
Message-ID: <X85spIzp1/gRxvKr@google.com>
References: <20201205004848.2541215-1-willmcvicker@google.com>
 <X8tMDQTls/RcTSAy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8tMDQTls/RcTSAy@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 09:59:57AM +0100, Greg KH wrote:
> On Sat, Dec 05, 2020 at 12:48:48AM +0000, Will McVicker wrote:
> > The HID subsystem allows an "HID report field" to have a different
> > number of "values" and "usages" when it is allocated. When a field
> > struct is created, the size of the usage array is guaranteed to be at
> > least as large as the values array, but it may be larger. This leads to
> > a potential out-of-bounds write in
> > __hidinput_change_resolution_multipliers() and an out-of-bounds read in
> > hidinput_count_leds().
> > 
> > To fix this, let's make sure that both the usage and value arrays are
> > the same size.
> > 
> > Signed-off-by: Will McVicker <willmcvicker@google.com>
> 
> Any reason not to also add a cc: stable on this?
No reason not to include stable. CC'd here.

> 
> And, has this always been the case, or was this caused by some specific
> commit in the past?  If so, a "Fixes:" tag is always nice to included.
I dug into the history and it's been like this for the past 10 years. So yeah
pretty much always like this.

> 
> And finally, as you have a fix for this already, no need to cc:
> security@k.o as there's nothing the people there can do about it now :)
Is that short for security@kernel.org? If yes, then I did include them. If no,
do you mind explaining?

> 
> thanks,
> 
> greg k-h
