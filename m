Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8BD5F77AC
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiJGLwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 07:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGLv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 07:51:59 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D36BBCBAB
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 04:51:59 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d12so1423143qtp.3
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 04:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fU2FABDO9NxbrC/6cLEAO8gNFaIBYJLtiRiJYi+uc3Q=;
        b=IB9DawzVgKE/tmvTC2F1LNnhlxFSN0+PGn99fXIPp3rcSYsViYl5pWyQuZR2MF3opx
         69tM3s66nt2CV2LvlXq6dcTj5OdBG2OSullL82QtZU5fFLGwqoezutRFAR3SqEBFK+aO
         GxZwXb17b2hIfJGNlbeIsgFsPrl1+alezAK0bze26Q2/QUP3i8tRwCWxa6hLyvfUEooF
         rFOfP2ZKdWY2MkGRDhB3HBahzGYGukKORCikPtlogKH6DvvkaWWkvLdK4ilUYRlkb4YR
         iMFuFYIdkUv42290PcFJ8MKmbACahUXgctWP2S80f7oJpbxTfFn8z09XoQ0R7xAnZypD
         50iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fU2FABDO9NxbrC/6cLEAO8gNFaIBYJLtiRiJYi+uc3Q=;
        b=EZM3sBZHN3ue31Vf/6AmJCGdDBfTTT6XM/zumUTHsg7fUKYedQEdLMIlxURCHUa+9A
         /uJM+q4WF+e5INXzdhnalHzzMp7HPu71BE4Nhee27uwxXsDeeBtycY4AVxWyps3AlRV5
         nRkW5BwnD++glzvheXzAg/xvRJZt3IZztPVVyeoJMQ7RnyWoqPfpcfvT29ANFiPyVo+y
         FE68QBjxUeZO9VnbUG4HTkHNIPdrPN4xNjb77LP548gLkPQLi2XEkcdCpkcBLbEgUFth
         fzaQpca0GwExHnhZ2TIMnLPaNcqVHDCoz4nugU9DVQEjwEr5LBZK9mRxaiW7PNkzABTV
         4BBA==
X-Gm-Message-State: ACrzQf3D4+hXjUb7IkqZHqsIPIC1tI7Yxr4PcvTHVt0qPe+2s1qFBo92
        yiRJP74525NQqoONFPRFPt7efcM1T8MjJnHZp40=
X-Google-Smtp-Source: AMsMyM4jwFxVzLMUAaE9r2FnOpH1fxQVBjk+LF5djNJQTbxR0rGDsFXhDDjgn6qJHzp/7GuJZjSHoz6BPjfX9tQqvbc=
X-Received: by 2002:a05:622a:282:b0:35d:4999:10cb with SMTP id
 z2-20020a05622a028200b0035d499910cbmr3642482qtw.191.1665143518212; Fri, 07
 Oct 2022 04:51:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: ouromachi@gmail.com
Received: by 2002:a05:6214:4002:0:0:0:0 with HTTP; Fri, 7 Oct 2022 04:51:57
 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Fri, 7 Oct 2022 11:51:57 +0000
X-Google-Sender-Auth: NNjKuf9IBblc9DHVV463npIuyb0
Message-ID: <CAJHYYr1L9HA4Vv7O8EipAe4sTscAKM=fgHR4LJ1q_kksjxc5eA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RG9icsO9IGRlbiwgb2JkcsW+ZWxpIGpzdGUgbW9qZSBkdsSbIHDFmWVkY2hvesOtIHpwcsOhdnk/
DQo=
