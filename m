Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B534248CD73
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 22:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiALVKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 16:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiALVKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 16:10:18 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC35CC06173F
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 13:10:17 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id pj2so7560767pjb.2
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 13:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=z6wZuyfU4PIZLdN6GhnWndbj3xwUMfYORUiEx/YCCNE=;
        b=gAo3BBE4rtXqgYMojmedqc4lS9SUB+KCcrLhtxUeHCCqdpjpO8SYdXplk00Ox/ac6Y
         u8HD0Fnn9QW7VdxV0PzJ2DrX6PwbYNeKc+VgWsNFJtAGd5Cw+LvNs8hlOpnsYFghTlqG
         B/0T0gZrrMxW8y5EZY9uTDlqFa1zpdlcJV3CJvRkO5yTC8Zdd4Gb2Er8uwdgUj6L2eHP
         X95IVNJb0yQxtN5lX7leJghqPv9AsY5ERWz/t0chTohwdXr7VMmE+alFdYR/AQW/SrXF
         5GZ7gnoxFoQHWm7zU992Npd1NOqxKLkb9PHn4GLBOtUIM+9JT5tauD9uGJ5arcPhnF1h
         qa7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=z6wZuyfU4PIZLdN6GhnWndbj3xwUMfYORUiEx/YCCNE=;
        b=VQuh75M1YiqKCspvpcZbP/CSUT5kbeqs2WC4K16ghnFVuhvuGWMaF2JFT9OZaK8ShL
         f04qmywzKBzZo0oW0L//to2lJo3DSgZkwkpvvzCxTmEp8gSWudKv4l9BMfvRMDsMk0r4
         mgymhG7AbC/VELTDRFKlLtqttOKlmPHILQ+FB7dUOBzgec9EmvH9rapVHNbHaikK4fDB
         yVApqbUlOSHWa2m3BjYmxT9QL/O2JliEXhh+0NZK8bkKeoD+8E4dbqdIhyhbje4KPRie
         6ffwua96MTVnPpwF5f3eilZJ4DtsV46tMDKkR+DD7HMfZ/NSuAKDUcD6aisytes75Hiz
         692w==
X-Gm-Message-State: AOAM531lm5Mc/80lNTnw+k+8myc71/7qpS2TNxT+W4o4kkNz+AnIK4Eg
        MW2xhd0X20wj/TzogCmf1LufzNKkFpG4wQ==
X-Google-Smtp-Source: ABdhPJyRcTaI4H7VoI326ZoEta3Xkypy5g7cc1xaO96LNe4ILJatPu/uE5nqzpPpKtmaMPxmaoczlg==
X-Received: by 2002:a62:3883:0:b0:4bb:9ad6:fff4 with SMTP id f125-20020a623883000000b004bb9ad6fff4mr1187904pfa.30.1642021816875;
        Wed, 12 Jan 2022 13:10:16 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id d16sm494411pfl.48.2022.01.12.13.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 13:10:16 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 12 Jan 2022 11:10:15 -1000
From:   Tejun Heo <tj@kernel.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Workqueue -stable request
Message-ID: <Yd9Dt6DndAeodDUk@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Greg.

The following two patches that just pulled by Linus need to be backported to
-stable but don't have stable tagged on them.

 v5.2+ : 07edfece8bcb ("workqueue: Fix unbind_workers() VS wq_worker_running() race")
 v5.16+: 45c753f5f24d ("workqueue: Fix unbind_workers() VS wq_worker_sleeping() race")

Can you please include them in -stable backports?

Thank you.

-- 
tejun
