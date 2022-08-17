Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FBF597453
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiHQQjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 12:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbiHQQju (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 12:39:50 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14B27754C
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 09:39:49 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id i77so7504920ioa.7
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 09:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc;
        bh=/gzITbBOSXEpQZ+33UkvJIctPu7Cvz10am8YtntRnMQ=;
        b=D6zloU9LFHF72iAaMNBVoQdshbJBjnIbh2Cb5XLA6brbO02MW1bunNanTe1vn/qgXM
         ECbZ6A6YqKb7dM/rjw39yepr37eEZkthexACrbvpcak3xW3EUlRH97EMb1DIn2Hg+yx9
         6vQvO5ubzb/Gs5HFI6KbqtqkVKcJRyutqMCUh8LrrjgDZ7sRwgZfPCJZtnXXcgSgH4YX
         FHdIlBJCZ7tfACcxeVTwld0X6Fdr6HpuVR8j2Kt6IjBvGlqcWfNm8jBHmiK1NpkIuGlC
         WIZGh+1DRDd2UwofkD/X7VTzcFp2bvde6xNmyt1CkYLapNn6vpnqNahEyTxXRDgvkc+I
         jigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/gzITbBOSXEpQZ+33UkvJIctPu7Cvz10am8YtntRnMQ=;
        b=WCX4bp0SP8AnnrffoMYLkgvqBAlZdcSOkbO4NMZ752BMOZsDSS9EBsCf25XmHhALFj
         8TotfWRSFDGtGjj4XiOZ2P9ykvtdazYbGEkAa1neP0gjir/xJkkSfvozP31QrAG7zehi
         Zk4nbWo05OSUTO8wvo91BwxUw85R7QmZ9/9QR4/BOysA4I3HYdBe3JuKplZ6wWMVngtA
         o5gyb8y+BMpX4/e4X0wwAmWoIRCVw/onJcttlMrKTuceZUQW+8de2MmpHqOuHGyswomy
         NgEhhoLk/AnSaiUxGnhXZrUNBZYU+VdRvYg2g8Q4zuZBXk9GeQOmdO/8f9m30roIhl/F
         RqVA==
X-Gm-Message-State: ACgBeo1AqaNSg1+5B5ME+rXHFX3iqwED+Z1EA6z7PbOjoBTh9Me6aXq/
        +WKyk1345HXxjrs0A6odfa+yTGJi3vIYUjpRWAs=
X-Google-Smtp-Source: AA6agR5nsK7OGzjBQoRgx5ktYbjlP3TsEDCm8XUe4hjHNRCSM7D8Mjma6uGHiD06rVB/vHxPDO4vzmVWNbgpQeE1GP8=
X-Received: by 2002:a05:6638:130f:b0:346:b950:cef4 with SMTP id
 r15-20020a056638130f00b00346b950cef4mr3205557jad.59.1660754389319; Wed, 17
 Aug 2022 09:39:49 -0700 (PDT)
MIME-Version: 1.0
Sender: crise2000oteng@gmail.com
Received: by 2002:a05:6602:148f:0:0:0:0 with HTTP; Wed, 17 Aug 2022 09:39:48
 -0700 (PDT)
From:   Pavillion Tchi <tchipavillion7@gmail.com>
Date:   Wed, 17 Aug 2022 16:39:48 +0000
X-Google-Sender-Auth: BcG92vklsv_8uNZi81G3D2vz4RQ
Message-ID: <CAFMnUVZi=Fr4FV+ko4=u4=h5Y_XuZoyDgrdBub2ZiYGSrcOpVw@mail.gmail.com>
Subject: Ahoj
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Ahoj
Obdr=C5=BEeli jste m=C5=AFj p=C5=99edchoz=C3=AD e-mail?
