Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADF96CF9B5
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 05:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjC3Dv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 23:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjC3Dv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 23:51:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7B9526F
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 20:51:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q102so16057649pjq.3
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 20:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680148282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfaEKbHlxcDpQyDfqMHkFVO6udphzWYYckZsypoMeuU=;
        b=FgZLEpBSqnJ0JtfnJZIOAN0syRSLSzWqrGkgpyTIk1KxEQ5YVtPx/bCeXT7p1eRyhZ
         arfwMhY/ixWmd75ItgbqiO8WbzKn9w0v3XEWWtuI2Zz0YBHPpJp0NhPZx+czEIXihVyV
         6BFCJcEfrCgEOU42k4m31afG4APJfT2DUF1ALJB6sTD2uRkR/9UZNpadygls7ztmViHG
         j66kpptbddTi9h3kUymYfSTTvzBFGbJPT5QJ+PWOYlFs/fnuFMGCVGPdUhRgLEFo0S8U
         OhohaV2fdyj9a6G4VFRc3bJY9xgsjngze6nPpXhk7QWUYAsPRRSXEQZeeHkpudtxehu8
         X2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680148282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfaEKbHlxcDpQyDfqMHkFVO6udphzWYYckZsypoMeuU=;
        b=ZfYR5v6YqA1dq2Y9cw2DNUL3Lz/uzSIJ0pxiMBwHrIVzYY3+ql+DDGkTiVLHvSr1e2
         pWMxpp/ZPhcFElYrP49npc37Y0no+i4AThSHQmBWacKmnzLx0Jp4ei5pFVBk3gFCkMDv
         qyWVHNBqn12m0IrcEYI8ZwZRhuUBuqSGjkhBT7DgkB2SK2USRr5MbLC1e2TQI84cG0+n
         zag5LlEBL9+F8evOFvFL64p44B6eZW4yoqbybn5ixdDdX/sHo5dH9Aygwshi2+Kw0/lE
         r5UR1/igc0VGW8qx4YyQxF+wP9A1xRH2uaOqZyUV5jIBPCT2a/bpN7IyAANkTNkNMKXb
         uWOA==
X-Gm-Message-State: AAQBX9dDOqCZABYqUV2PVN77F57SPDeoFTTJkrcVw7yFekRPxEZrOB/d
        wCIhFW7pnqYqrXEe+k9oIRu/9JNSvSxaFRci1xs=
X-Google-Smtp-Source: AKy350ZUwc3lGJetis3wG6jM4CyIps2QFGmpMbxIgjrXH+3pZZFjsTKLtQ6/bikQbrExueg+U1BlNA==
X-Received: by 2002:a17:902:e485:b0:1a1:cce7:94ed with SMTP id i5-20020a170902e48500b001a1cce794edmr16132363ple.67.1680148282066;
        Wed, 29 Mar 2023 20:51:22 -0700 (PDT)
Received: from localhost ([122.172.85.168])
        by smtp.gmail.com with ESMTPSA id iw21-20020a170903045500b0019aa8149cb9sm23861404plb.79.2023.03.29.20.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 20:51:21 -0700 (PDT)
Date:   Thu, 30 Mar 2023 09:21:19 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpufreq: qcom-cpufreq-hw: fix double IO unmap and
 resource release on exit
Message-ID: <20230330035119.xujtztfcugzy5kuj@vireshk-i7>
References: <20230323174026.950622-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323174026.950622-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-03-23, 18:40, Krzysztof Kozlowski wrote:
> Commit 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data
> during probe") moved getting memory resource and iomap from
> qcom_cpufreq_hw_cpu_init() to the probe function, however it left
> untouched cleanup in qcom_cpufreq_hw_cpu_exit().

Applied. Thanks.

-- 
viresh
