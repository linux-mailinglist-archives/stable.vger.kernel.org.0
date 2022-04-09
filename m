Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E254FA9F7
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 19:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiDIRkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 13:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiDIRkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 13:40:13 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8C32675
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 10:38:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id bg10so23138140ejb.4
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 10:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=MYJF9KiPtrV75ozAVMvpoRlE3JFtLvnDEoDPUbFexZs=;
        b=eHslSmW23JOULrliKW4sAwXSr7FdbN4xDQ4VMQWRocb+FMhpkxNzBlcf17Jyhctuc+
         uVK0/qfQK9jSg0pXLNSby+KCi0Nhx6ql16hyU1zjutrCK75dOqsO4/n+Tv75YgHSnmhJ
         ZXu7KTMuQBOUwIIwG5A6Mlmq4NXTdU2VGiQaN/aJTTS1TLejE0L9ZuZZ7tQojkawpga2
         ZSdIh4Qpm6buQ/xLehLJ+P4c0CwlB8CQOvdygH7uboKrU7V/i0JFgW87i0eqdMZbfS73
         4bmoYL394QJzvcEsmE2xO+tJDuzOu5nRfVISVzcT7wy+sZQROHcl1BVP5orFPuP+aIVd
         akkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=MYJF9KiPtrV75ozAVMvpoRlE3JFtLvnDEoDPUbFexZs=;
        b=krR6/c5j1zLonn9LdVerI80UwSs9zvggSy+HIo8YW2XAQbvZB9DOWbOuhpoNl4jK+y
         Nns9t5sdQkj2EI3T/l7RqP3XACmfU2o28HCHsJJopS3ojx9IIMoaCILAboBgjwynVT5v
         FWOcW/ms2AgRm+mc4L+b/3VIgie9Y1fPy0A8WRkNj+hGwiBSVY56fQakeTVLAAFrDYpj
         w85awnI4HsyLgLczhnnOS0WCafAjwXVYCCdOLlXooJeUxjCzLOOQrXUBhDwjtDJ6e3Zw
         8RLtSbGlnX/ABcWe0NFVV1XAFeRoGVkQF/fy0BQq7LxTxwz+4uu7wRlct7y7rhb0svdN
         nQuw==
X-Gm-Message-State: AOAM530Tg0bQuKovJEuLC3F/tFUtUh5/dASjWFsF27jgeYamp88rFh4V
        U9Y63rLRY5S+kItPaTMaBQqI8TpS9L7I/Q==
X-Google-Smtp-Source: ABdhPJwpBVrwiLFah3B8eN1B4sfazARZinNbKQUPnILHHoXrVjoZX3Fc88c1opI6Yr2zFSRn7C9oGA==
X-Received: by 2002:a17:907:9868:b0:6e8:7ae3:7f42 with SMTP id ko8-20020a170907986800b006e87ae37f42mr1528529ejc.224.1649525883979;
        Sat, 09 Apr 2022 10:38:03 -0700 (PDT)
Received: from mainframe.localdomain ([118.137.7.161])
        by smtp.gmail.com with ESMTPSA id go40-20020a1709070da800b006dfc3945312sm9884966ejc.202.2022.04.09.10.38.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 10:38:03 -0700 (PDT)
Date:   Sun, 10 Apr 2022 00:37:50 +0700
From:   Ketsui <esgwpl@gmail.com>
To:     stable@vger.kernel.org
Subject: Please backport commit dfbba2518aac4204203b0697a894d3b2f80134d3
Message-ID: <YlHEbgyXT9crVF7O@mainframe.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 87ebbb8c612b broke suspend-to-ram on kernel 5.17, trying to resume
with it results in an unusable system. I've tried reverting it from 5.17
and found that resuming works once again.
