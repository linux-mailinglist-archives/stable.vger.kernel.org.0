Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AF45468EB
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 16:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiFJO6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 10:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiFJO6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 10:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1E4C55B3
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654873121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=R40L0xAEVrInYspBIv9TMWq0uA/5zu4pr2h8mAyDv2U=;
        b=FDVN3fqQWdLY8jtUmmgSNXX8nuszpxNExLck+aUUIHdQSji5+ruC/idGP5m/b2F59wRSwY
        y4vubiY6GqKiD0WFINb8Rm1+hJTjsoncanVos4UZC3S79uUfveN2upQG7bQigpByplxTyR
        FTa1t7jKOHF0OLVuTAFfZnLp2wIeXmo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-K8qdC8MqO9Sei3l6-e-6rw-1; Fri, 10 Jun 2022 10:58:40 -0400
X-MC-Unique: K8qdC8MqO9Sei3l6-e-6rw-1
Received: by mail-wm1-f72.google.com with SMTP id k34-20020a05600c1ca200b0039c7db490c8so958993wms.1
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=R40L0xAEVrInYspBIv9TMWq0uA/5zu4pr2h8mAyDv2U=;
        b=gpjoeys8oOF4hALji3DJeJ1Fidpl4GJ71NBwwt45PK4NjZggDtegLJKh+baBIRjDnU
         5pzewfrO4fQlLUg2WK8KrUgdBSqHIZEj0y3pBAk7ikF3iiWUr3lkK0MTt4Zgb/cVtsnG
         BtIdNzgN446HHLm/OT1E0ZPcz7x5qQ9AU7nyh8c/RPxWIDcr4Qbckze5JZ3DOAPW1FJQ
         tixPZhucSe1cANhYQ6EwpKwOxh8cJ+1AiedIisI/GjIHpMYQazvkd+qT9UMWXJaLcwMv
         yikZW1ezRHw4a2Xr+x5OYBNw4GxPi8wz749Iegi3jhmUe5fbyRFX8KM4fgmnsi6sYDgu
         7QOw==
X-Gm-Message-State: AOAM531LCg9f8w40F01NU8rivTTGme3IDb7l2ZXnG75U5d3DGYI47MGp
        FdoNoNNoNKUb7qm/NpXHwaCfHqcjyfw5Gog4XRkLOCYOFG6GstlLJNmC1nqQ+8X0Oqyb7WggHTO
        YRZd1W+PC0adqwWnZwoYx7T8NkkLTo+YpkxlYUcd5SvDTFcTJ8F6nbEVlA0SWqnNtzKnk
X-Received: by 2002:a05:600c:1c11:b0:39c:80b1:c3d7 with SMTP id j17-20020a05600c1c1100b0039c80b1c3d7mr196332wms.2.1654873118558;
        Fri, 10 Jun 2022 07:58:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOk7/C2kdQpZioU60rdppdgCgxve4Q8BiL6YMo0aCU5+fe64VZG4RUzHS8lI9cpmqgK0RdOA==
X-Received: by 2002:a05:600c:1c11:b0:39c:80b1:c3d7 with SMTP id j17-20020a05600c1c1100b0039c80b1c3d7mr196309wms.2.1654873118295;
        Fri, 10 Jun 2022 07:58:38 -0700 (PDT)
Received: from localhost (net-93-66-64-158.cust.vodafonedsl.it. [93.66.64.158])
        by smtp.gmail.com with ESMTPSA id d11-20020adffbcb000000b002183ee5c0c5sm15213401wrs.50.2022.06.10.07.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:58:37 -0700 (PDT)
Date:   Fri, 10 Jun 2022 16:58:37 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     stable@vger.kernel.org
Cc:     echaudro@redhat.com, i.maximets@ovn.org
Subject: net/sched: act_police: more accurate MTU policing
Message-ID: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello,

Ilya reports bad TCP throughput when GSO packets hit an OVS rule that does
tc MTU policing. According to his observations [1], the problem is fixed
by upstream commit 4ddc844eb81d ("net/sched: act_police: more accurate MTU
policing"). Can we queue this commit for inclusion in stable trees?

thanks!
-- 
davide


[1] https://mail.openvswitch.org/pipermail/ovs-dev/2022-June/394802.html

