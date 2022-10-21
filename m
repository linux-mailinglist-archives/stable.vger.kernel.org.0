Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41BE607964
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiJUOVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 10:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJUOVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 10:21:43 -0400
Received: from ya.lv (ya.lv [138.201.201.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FB1265C69
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 07:21:38 -0700 (PDT)
Received: by ya.lv (Postfix, from userid 5002)
        id 10925923DA6; Fri, 21 Oct 2022 17:21:36 +0300 (EEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ya.lv 10925923DA6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.lv; s=default;
        t=1666362096; bh=ygvdPaoH78vwuJnHAJl83wyJdjt768cE8RoO54kVks8=;
        h=Date:From:Subject:From;
        b=F+pZSr/xXcQPeGv/OlVwnpiGjo9Dmt0XU1QwtyR8TjML0bkvYYCCkvHfOn+GWj72L
         FhJHdDINWKgo2kWAUkBY/TFeAyrZHNdrz5AqZl1ZHrPVENQyPSJ/KVYJxwomnAHRjn
         WT4szh3+VuWyxhyNhWt2jI2J3hAv8wgMLSMOeBZk=
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_20,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        SPF_HELO_PASS,SPF_PASS,TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
Received: from dummy.faircode.eu (unknown [138.199.7.234])
        by ya.lv (Postfix) with ESMTPSA id 5C8D8923D8D;
        Fri, 21 Oct 2022 17:21:32 +0300 (EEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ya.lv 5C8D8923D8D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.lv; s=default;
        t=1666362094; bh=ygvdPaoH78vwuJnHAJl83wyJdjt768cE8RoO54kVks8=;
        h=Date:From:Subject:From;
        b=V00wLfjUcyqAwZWXjOM17v/QghJqxeVkocdq5hW4B1iPkYx93wRR+IVMJrDfXsBY/
         sOaLjwX2TDTnqRS1mOjbfVVx9LyzBMdNG83W3yzzpsRphgHo8gH3GV04zbHqXGWKnf
         XSocpPCQTndNm8cY+893uP4GgZBmXGjaykBK/bQE=
Date:   Fri, 21 Oct 2022 03:54:34 +0000 (UTC)
From:   TRANSPARENCY <TRANSPARENCY@YA.LV>
Message-ID: <a5c19f7c-17fd-4446-be44-aa5e48ad48e7@YA.LV>
Subject: Import
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <a5c19f7c-17fd-4446-be44-aa5e48ad48e7@YA.LV>
X-Spam-Level: **
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://privatebin.net/?dd3ba1f39dff96e4#6xWvHDF6u11khopQ7nnCRL6E9w1K2G42cLqPyyY7Yq6T
