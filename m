Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12073648C3
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhDSRJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 13:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhDSRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 13:09:50 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2550EC06174A;
        Mon, 19 Apr 2021 10:09:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id v6so52779731ejo.6;
        Mon, 19 Apr 2021 10:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90zlVLl1e9V47BXJfzWbLa36NO+xMYd8xvZgNoKBdDg=;
        b=tDld1tfpIleYZm1JrQA0bkid38a7Z4EgPn0GiNKBVSA5NOZxk2ezTnfVjKoMHSxWJY
         DawBSaY9G2EK4qHADjg2y8mVa/HW3hRSj7n5F4hFnCcqdfoM7xwpu+IYVwg1AVaYAmZV
         yqNqaUBbz0JK0O2Z7tnCMyz9sfimp1yOyIx15j/QZCuGFL+mBCLbr6b9K097oYooHU1W
         N6tuyAK48Ic+7khSY65X33DP5RsGu/IZ6zurATrIKCAu9/t3AAF6cFmQTFvvmTyv6ldM
         3Y2JPzCG0kWeSeD4mjOhyClwpZBu1ZttSKUZgpIwes/jeV2ERQ90aR2YE+MbkqkOBpov
         kbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=90zlVLl1e9V47BXJfzWbLa36NO+xMYd8xvZgNoKBdDg=;
        b=Djkg9iE18a/6i9X1OtnIU80REU0zNxQnozm/ecAV07LOp8iSbu9L366tc0FGo0rJ6K
         Q0uGVNZNOoZNZ6fwLDSlD4O0MGYqIK+HZ6m5f0NVClWfEvOqLEcJb7NPDamiWYFm/7C3
         44C3KHFmAb0Z1VztZa+7r/iqW15tsybY+n8EJ/nr/Sf6NOWEFEH311V0P9NxeO9/HcTB
         6oz/8VrhO21WtXrwO/C7a2H2nhmcfe3M1G5nRkCLnQYNfleA2YyOnukk6wu3BiJNIYXH
         rkGl/QJxYrwPdL/pe22aOvRKVwuA6MLdZF7UTMkovuWub9MUe0MomXHMhK9BrA5jjn7H
         eaCA==
X-Gm-Message-State: AOAM533jIAVyCxDMEFyv3nhwmB50Cjz2i7SBZiFhRNTo7EVAsA7+gncU
        US7Ep8NPHhLNFWL6paDqpN8=
X-Google-Smtp-Source: ABdhPJwK2BcO+w77AIQEvbx/NH4axkeHyE/1oUV3KOihUIRIQdkOxB54wRxAy4dJgCacdL3sD9HL1A==
X-Received: by 2002:a17:906:f210:: with SMTP id gt16mr23028778ejb.22.1618852158879;
        Mon, 19 Apr 2021 10:09:18 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id bu26sm10761969ejb.30.2021.04.19.10.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:09:18 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Mon, 19 Apr 2021 19:09:17 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YH25PZn5Eb3qC6JA@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com>
 <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shyam,

On Mon, Apr 19, 2021 at 05:48:24AM +0000, Shyam Prasad wrote:
> <Including Paulo in this email thread>
> 
> Hi Salvatore,
> 
> Attached is a proposed fix from Paulo for older kernels. 
> Can you please confirm that this works for you too? 

I re-applied commit a738c93fb1c1 ("cifs: Set
CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.") and on
top of that your provided patch, and this seems to resolve the issue
for the testcase I have at hand!

Regards,
Salvatore
