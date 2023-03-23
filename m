Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5BD6C6F7E
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 18:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCWRlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 13:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCWRkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 13:40:43 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C199419119
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:40:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so90187907edd.5
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679593232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ONmJsFn4VtTyqhV76hclBRWNA9ptPEzWzjO41FRshbk=;
        b=ZOOMx6qRt3g7nOII6cvvW0hyxEjWWWvDyB98rJc12tcsH6noQhIsqu5xLxTof0r+F6
         Fk6ByrMV8UwbwL7tUhXCMW1/tQSupmgreeis3cnrbTucwxJBVGbIiXo47uHi1RmFtad0
         NfcBboj+c0EQ0W89ocXkpz6EoGXfx8QSla2bJ2Yp79BR1UJTy1y9u77coZDKkC/wVe/o
         Iz1oE7G00uYZTSzJM9ApeuHNhP8WjV+yLj3GpTAYs4gp1Is9P5SwwM8n1y5WJVPzVR7l
         r1tuvwipZ6u/wfdNztLFTIOVgRjlAmxDsrgCPJjuKVfrWG4i2K3jtA8FZ3Ll3veAvA9K
         ZkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONmJsFn4VtTyqhV76hclBRWNA9ptPEzWzjO41FRshbk=;
        b=7Q8/1nmNFNJZu+9xatL3mKzQPf1KgrPPqdr6i2NWa6CZDozQuOa+abQcYxkrJs9GTz
         t/I4PGkXv3FWuRU2OUclXGfkHOPoQqFSS3Rkcy+bpMxOjxqL90E37ys+QiFyRAMt+vHR
         GsgguYraXNW2TboBzjrL1JJJfGfrVvLSPIYz9UOh+IMaNcM0MadjbdpCA+OWiUstiMEO
         o3Y/6K/vT0eMOIfqRzIITyFdPbPPJIIdBijOxAl1e1GipC9rHDfjzu4PSEEwpW5w7mIx
         CBod82Gpc1iFj6rKegnSz06WJCQYGn8Jc8mk0C5g9cuU/5jHOZd6c0W3wKBktE5rsEg2
         r0QQ==
X-Gm-Message-State: AO0yUKVGuodzugqCzzQqQNTqvbnv4+ND+KlGN+fETFeOYWGG+r4GGZUy
        luC68lYiXSGcfB5p89+w03McLw==
X-Google-Smtp-Source: AK7set8rJQZ+O/FCvIPcGJhP6YlCEw19hFeuaPslN52OzsFHLjmX9FRAHXgcMjsK45mV7kDxLqZerQ==
X-Received: by 2002:a17:906:378d:b0:930:7ae6:9ebd with SMTP id n13-20020a170906378d00b009307ae69ebdmr11866028ejc.70.1679593232231;
        Thu, 23 Mar 2023 10:40:32 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:d350:23b1:cb94:f39d])
        by smtp.gmail.com with ESMTPSA id e5-20020a170906314500b009236ae669ecsm8890787eje.191.2023.03.23.10.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:40:31 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] cpufreq: qcom-cpufreq-hw: fix double IO unmap and resource release on exit
Date:   Thu, 23 Mar 2023 18:40:26 +0100
Message-Id: <20230323174026.950622-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data
during probe") moved getting memory resource and iomap from
qcom_cpufreq_hw_cpu_init() to the probe function, however it left
untouched cleanup in qcom_cpufreq_hw_cpu_exit().

During device unbind this will lead to doule release of resource and
double iounmap(), first by qcom_cpufreq_hw_cpu_exit() and second via
managed resources:

  resource: Trying to free nonexistent resource <0x0000000018593000-0x0000000018593fff>
  Trying to vunmap() nonexistent vm area (0000000088a7d4dc)
  ...
  vunmap (mm/vmalloc.c:2771 (discriminator 1))
  iounmap (mm/ioremap.c:60)
  devm_ioremap_release (lib/devres.c:19)
  devres_release_all (drivers/base/devres.c:506 drivers/base/devres.c:535)
  device_unbind_cleanup (drivers/base/dd.c:523)
  device_release_driver_internal (drivers/base/dd.c:1248 drivers/base/dd.c:1263)
  device_driver_detach (drivers/base/dd.c:1300)
  unbind_store (drivers/base/bus.c:243)
  drv_attr_store (drivers/base/bus.c:127)
  sysfs_kf_write (fs/sysfs/file.c:137)
  kernfs_fop_write_iter (fs/kernfs/file.c:334)
  vfs_write (include/linux/fs.h:1851 fs/read_write.c:491 fs/read_write.c:584)
  ksys_write (fs/read_write.c:637)
  __arm64_sys_write (fs/read_write.c:646)
  invoke_syscall (arch/arm64/include/asm/current.h:19 arch/arm64/kernel/syscall.c:57)
  el0_svc_common.constprop.0 (arch/arm64/include/asm/daifflags.h:28 arch/arm64/kernel/syscall.c:150)
  do_el0_svc (arch/arm64/kernel/syscall.c:194)
  el0_svc (arch/arm64/include/asm/daifflags.h:28 arch/arm64/kernel/entry-common.c:133 arch/arm64/kernel/entry-common.c:142 arch/arm64/kernel/entry-common.c:638)
  el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:656)
  el0t_64_sync (arch/arm64/kernel/entry.S:591)

Fixes: 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data during probe")
Cc: <stable@vger.kernel.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 2f581d2d617d..b2d2907200a9 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -43,7 +43,6 @@ struct qcom_cpufreq_soc_data {
 
 struct qcom_cpufreq_data {
 	void __iomem *base;
-	struct resource *res;
 
 	/*
 	 * Mutex to synchronize between de-init sequence and re-starting LMh
@@ -590,16 +589,12 @@ static int qcom_cpufreq_hw_cpu_exit(struct cpufreq_policy *policy)
 {
 	struct device *cpu_dev = get_cpu_device(policy->cpu);
 	struct qcom_cpufreq_data *data = policy->driver_data;
-	struct resource *res = data->res;
-	void __iomem *base = data->base;
 
 	dev_pm_opp_remove_all_dynamic(cpu_dev);
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	qcom_cpufreq_hw_lmh_exit(data);
 	kfree(policy->freq_table);
 	kfree(data);
-	iounmap(base);
-	release_mem_region(res->start, resource_size(res));
 
 	return 0;
 }
@@ -718,17 +713,15 @@ static int qcom_cpufreq_hw_driver_probe(struct platform_device *pdev)
 	for (i = 0; i < num_domains; i++) {
 		struct qcom_cpufreq_data *data = &qcom_cpufreq.data[i];
 		struct clk_init_data clk_init = {};
-		struct resource *res;
 		void __iomem *base;
 
-		base = devm_platform_get_and_ioremap_resource(pdev, i, &res);
+		base = devm_platform_ioremap_resource(pdev, i);
 		if (IS_ERR(base)) {
-			dev_err(dev, "Failed to map resource %pR\n", res);
+			dev_err(dev, "Failed to map resource index %d\n", i);
 			return PTR_ERR(base);
 		}
 
 		data->base = base;
-		data->res = res;
 
 		/* Register CPU clock for each frequency domain */
 		clk_init.name = kasprintf(GFP_KERNEL, "qcom_cpufreq%d", i);
-- 
2.34.1

