Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8854DBB86
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 01:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiCQANN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 20:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiCQANN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 20:13:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78DAE19C22
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647475912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HRMd8ZYnny9EZT2zr6hpDc7X30tiCpEQBmnlGwthrok=;
        b=aO5ccl1VpwVvNsmvlyY4nnORrZUl2bx3x3IlgC9In3uzS+99Yx6mZjVDWzL6XBeYPLfw31
        mXaAyZFyY78y+fCGuT3mgNMnPNWX+sDiMOZDq+xS2Z6q/12sjHWl7C9MY9o7rEfF6jOC1t
        LpweXkVaJy0glDDL/LPfo2kHh/4yU3w=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-j9wqGBejMvS-57RiA5G8UA-1; Wed, 16 Mar 2022 20:11:51 -0400
X-MC-Unique: j9wqGBejMvS-57RiA5G8UA-1
Received: by mail-pf1-f199.google.com with SMTP id l138-20020a628890000000b004f7cb47178cso2549141pfd.12
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HRMd8ZYnny9EZT2zr6hpDc7X30tiCpEQBmnlGwthrok=;
        b=z4PQLU3f6jHKK/65lvoqBaY3LAV2Dh8wNpowGOwtcDG/Ksf32Oc7Betxvh4CoPNw7c
         0ww4sOHQJ1cL3MWXKNBm0nS0pe9OFo4vcKG01WyBOJNbDTNeZp4hjSGunj2TYVzZEVRO
         nlxJoeETd4T+vMXmWNQ5T1JyC6G4AcP1eUqJiolKvoTLzczNi36Y6G3/oONoW6fosIAj
         MSt1a0aFjY5AXf5J+4bpAUbwLaJ0VnTYpAY1JAwfgCGspFYL8lhFKPhGng6dJUvXycJf
         K3lURT498B35jYUJghhqIrj+FNdyaig5i54z+lbQe4T8SvWRzI0SDrPY05mZIhpNw2vd
         j05A==
X-Gm-Message-State: AOAM532EhzABzW7E4oXzB9PRH/yy4YnZPgDoQ6LJLWq3LzVaHhwHGZKM
        GlCP8WPU8OPwddG3OavF6NoPyeqEZU1v3Ro+Kx+1O0Ww/EBlkPoZxWS8pUx0HuMuQafIyQw0DTO
        WZMReYkEYR0SsgCS8
X-Received: by 2002:a05:6a00:a8b:b0:4cd:6030:4df3 with SMTP id b11-20020a056a000a8b00b004cd60304df3mr2025185pfl.40.1647475910067;
        Wed, 16 Mar 2022 17:11:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9NNWbYnnVvQ5V6vyo2WvlkekJzDgzdWMeVliKNTwPzm7bGsDML7f17IzKO/fTp5HlEYS2mA==
X-Received: by 2002:a05:6a00:a8b:b0:4cd:6030:4df3 with SMTP id b11-20020a056a000a8b00b004cd60304df3mr2025154pfl.40.1647475909736;
        Wed, 16 Mar 2022 17:11:49 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.230])
        by smtp.gmail.com with ESMTPSA id mq6-20020a17090b380600b001c6357f146csm7766127pjb.12.2022.03.16.17.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:11:49 -0700 (PDT)
Date:   Thu, 17 Mar 2022 08:11:44 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Nadav Amit <nadav.amit@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-ID: <YjJ8wO4MVwSUMhd/@xz-m1.local>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
 <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
 <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
 <3E9C755C-7335-4636-8280-D5CB9735A76A@gmail.com>
 <20220316150553.c7b6f9e0eac620c9ee5963a5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220316150553.c7b6f9e0eac620c9ee5963a5@linux-foundation.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Andrew,

On Wed, Mar 16, 2022 at 03:05:53PM -0700, Andrew Morton wrote:
> 
> As I understand it, this patch (below) is still good to merge upstream,
> although Peter hasn't acked it (please).

Thanks for asking.  I didn't ack because I saw that it's queued a long time
ago into -mm, and also it's in -next for a long time too (my new uffd-wp
patchset is rebased to this one already).

I normally assume that means you read and ack that patch already, so if I
didn't see anything obviously wrong I'll just keep silent. Please let me
know if that's not the expected behavior..

So here it is..

Acked-by: Peter Xu <peterx@redhat.com>

> 
> And a whole bunch of followup patches are being thought about, but have
> yet to eventuate.

Is there a pointer/subject?

> 
> Do we feel that this patch warrants the cc:stable?  I'm suspecting
> "no", as it isn't clear that the use-case is really legitimate at this
> time?

Right. Uffd-wp+mprotect usage is IMHO not a major use case for uffd-wp per
my knowledge. At least I didn't even expect both work together, not until
Nadav started working on some of the problems..

Said that, for this specific case it should be literally only changing the
behavior of anonymous UFFD-WP && !WRITE case but nothing else (please
correct me otherwise..), then IMHO it's pretty safe to copy stable too
especially for the cleanly applicable branches.

Thanks,

-- 
Peter Xu

