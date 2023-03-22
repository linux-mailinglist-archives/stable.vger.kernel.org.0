Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382DF6C4B00
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 13:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCVMre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 08:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCVMrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 08:47:32 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC3A5ADE9
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 05:47:25 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id y35so9312542pgl.4
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 05:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679489244;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=Y4JScDlUX2PtI0qleZc+T1hFGcNU6XQ24Rf20VvGtw340O2HmrsnlwonKUXx6CkGml
         wTsGIvyx0L+K6GgscBC7a+66Z+RTLIuAM0G1ral6oSwQLBsg/k3/n13Cr05efkedlkof
         yeEZPPWXurswyUrkClalPWA9S1pkJiQ8DcNYjDUqXsb/z5bUhLVV7vZ25vnCBjkcm5jl
         hpSC0JtRVBv4Zt9CIHPUPOQ/HhBAQ6a8mzDN3dowvlX+DFD3LtKsvHXqZrMIEu2dLgZF
         e+dkNuvuvuZTR3gca6xHmufSDrOu+6Vnc5r3UdPq0G6R1wlKMthnB8gv1Y6c6Ft9ctfB
         9joA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679489244;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=TexJytD1ziDhXFuCHKi0WDaA73E8uPnN2ambzTWYdo1EqRIbRiDcsTpWyhu17tpqmf
         eZq5EV0RCTs+PUKi4naU3r+P16dhOXItTD1nL7Dys9Yy3DT/8H7i2MMBcqpltFBsHxrD
         Dn+52qTodN10V8lnng0QZ3H5C2tQ23w/LxIMzGIevC710n00FQpny1mHNPfpyVRYn1bU
         ycE72i5+LqEnB3Pyt/R3lE0OSjUlIrCzZJzrPfxahhXQVgNt4Jsa4ptT6Y4tlp31p26W
         tKTO8OzBXDl6IiGcidQNe+s0CHVNnempHQqSe/h1th0nYLOvp9Zbsn442FS39e+rMyNO
         BlKw==
X-Gm-Message-State: AO0yUKXpiaPhJ0in2VmMeKkFoOYtY+WG1mV+eFEOs9+a8bWCPJtXQFTn
        yInekz56jgpVTawCpmNZkuMv/qib5KFjnh/vp3I=
X-Google-Smtp-Source: AK7set+9DbnVs187OLqosDr9IpsDfLXDAd6Vw0ghbIpOeo9ovgNf6RWqnan5YxXTziMtE23I342ZUsYCshnZnTtRT/8=
X-Received: by 2002:a63:9a51:0:b0:50b:18ac:fbea with SMTP id
 e17-20020a639a51000000b0050b18acfbeamr751112pgo.9.1679489244329; Wed, 22 Mar
 2023 05:47:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:522:86c4:b0:4e4:4a0c:2495 with HTTP; Wed, 22 Mar 2023
 05:47:23 -0700 (PDT)
Reply-To: ava014708@gmail.com
From:   Dr Ava Smith <adue84540@gmail.com>
Date:   Wed, 22 Mar 2023 05:47:23 -0700
Message-ID: <CAEW4dsjg_KvFF4LKUpXaf5EdX9-vkciwQiHd7Lwv49shQzwMew@mail.gmail.com>
Subject: HI
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
